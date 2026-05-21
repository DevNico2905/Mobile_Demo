const path = require('path');
const fs = require('fs');

// Cargar .env desde la carpeta del backend (soporta UTF-8 y UTF-16 LE, frecuente en Windows)
const envPath = path.join(__dirname, '.env');
if (fs.existsSync(envPath)) {
    const buf = fs.readFileSync(envPath);
    const isUtf16Le =
        (buf[0] === 0xff && buf[1] === 0xfe) ||
        (buf.length >= 4 && buf[1] === 0 && buf[3] === 0 && buf[2] !== 0);
    let content = isUtf16Le ? buf.toString('utf16le') : buf.toString('utf8');
    if (content.length > 0 && content.charCodeAt(0) === 0xfeff) content = content.slice(1);
    content.split(/\r?\n/).forEach((line) => {
        const trimmed = line.trim();
        if (trimmed && !trimmed.startsWith('#') && trimmed.includes('=')) {
            const eq = trimmed.indexOf('=');
            const key = trimmed.slice(0, eq).trim().replace(/^\uFEFF/, '');
            const value = trimmed.slice(eq + 1).trim();
            process.env[key] = value;
        }
    });
}

if (!process.env.DB_NAME) {
    console.error('ERROR: DB_NAME no esta definido. Revisa que backend/ .env contenga DB_NAME=flutterecomsalle');
    process.exit(1);
}

const express = require('express');
const cors = require('cors');
const mysql = require('mysql2/promise');
const bcrypt = require('bcryptjs');

const app = express();
app.use(cors());
app.use(express.json());

const pool = mysql.createPool({
    host: process.env.DB_HOST,
    user: process.env.DB_USER,
    password: process.env.DB_PASSWORD,
    port: process.env.DB_PORT || 3306,
});


// Debug: ver qué base de datos usa el backend y cuántos usuarios hay
app.get('/api/debug-db', async (req, res) => {
    try {
        const conn = await pool.getConnection();
        const dbName = process.env.DB_NAME;
        let count = null;
        try {
            const [rows] = await conn.execute(
                'SELECT COUNT(*) as total FROM users',
            );
            count = rows[0].total;
        } catch (e) {
            count = 'error: ' + e.message;
        }
        conn.release();
        res.json({
            database: dbName,
            usersCount: count,
            message:
                dbName === 'flutterecomsalle'
                    ? 'OK, backend usa flutterecomsalle'
                    : 'CUIDADO: backend NO está usando flutterecomsalle',
        });
    } catch (err) {
        res.status(500).json({ error: err.message });
    }
});

// Simple health check
app.get('/api/health', async (req, res) => {
    try {
        const conn = await pool.getConnection();
        await conn.ping();
        conn.release();
        res.json({ status: 'ok' });
    } catch (err) {
        console.error(err);
        res.status(500).json({ status: 'error', message: err.message });
    }
});


// Registro de usuario
app.post('/api/auth/register', async (req, res) => {
    try {
        const { username, email, password, fullName } = req.body;

        if (!username || !email || !password) {
            return res.status(400).json({ message: 'Faltan datos obligatorios' });
        }

        const conn = await pool.getConnection();
        try {
            const [rows] = await conn.execute(
                'SELECT id FROM users WHERE email = ? OR username = ? LIMIT 1',
                [email, username],
            );
            if (rows.length > 0) {
                return res
                    .status(409)
                    .json({ message: 'Ese correo o usuario ya está registrado' });
            }

            const hash = await bcrypt.hash(password, 10);

            await conn.execute(
                'INSERT INTO users (username, email, password, full_name) VALUES (?, ?, ?, ?)',
                [username, email, hash, fullName || null],
            );

            return res
                .status(201)
                .json({ message: 'Usuario registrado correctamente' });
        } finally {
            conn.release();
        }
    } catch (err) {
        console.error(err);
        return res.status(500).json({ message: 'Error en el servidor' });
    }
});

//login
app.post('/api/auth/login', async (req, res) => {
    try {
        const { email, password } = req.body;

        if (!email || !password) {
            return res.status(400).json({ message: 'Faltan datos obligatorios' });
        }

        const conn = await pool.getConnection();
        try {
            const [rows] = await conn.execute(
                'SELECT id, email, password, full_name, username FROM users WHERE email = ? OR username = ? LIMIT 1',
                [email, email],
            );

            if (rows.length === 0) {
                return res
                    .status(401)
                    .json({ message: 'Correo o usuario no registrado' });
            }

            const user = rows[0];
            const match = await bcrypt.compare(password, user.password);

            if (!match) {
                return res.status(401).json({ message: 'Contraseña incorrecta' });
            }

            return res.status(200).json({
                message: 'Inicio de sesión exitoso',
                userId: user.id,
                email: user.email,
                fullName: user.full_name,
                username: user.username
            });
        } finally {
            conn.release();
        }
    } catch (err) {
        console.error(err);
        return res.status(500).json({ message: 'Error en el servidor' });
    }
});




