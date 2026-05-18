const jwt = require('jsonwebtoken');
const { response } = require("../helpers/response.formatter");
const { auth_secret } = require('../config/base.config');

module.exports = {
    verifyToken: async (req, res, next) => {
        let token = req.header('Authorization');
        if (!token) {
            return res.status(401).json(response(401, 'Unauthorized'));
        }

        try {
            if (token.startsWith('Bearer ')) {
                token = token.slice(7).trimStart(); // Mengambil token tanpa "Bearer "
            } else {
                return res.status(401).json(response(401, 'Unauthorized'));
            }

            const decoded = jwt.verify(token, auth_secret);
            // Menyimpan data userId dari token ke req
            req.userId = decoded.userId; // Menggunakan userId dari payload token
            next(); // Melanjutkan permintaan ke route berikutnya
        } catch (error) {
            return res.status(401).json(response(401, 'Unauthorized'));
        }
    }
}
