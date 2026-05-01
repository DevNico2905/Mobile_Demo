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
