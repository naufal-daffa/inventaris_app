const express = require("express")
const router = express.Router()

const upload = require('../middlewares/upload')
const returnController = require('../controller/return.controller')

router.post('/:id/return', upload.none(), returnController.createReturn)
router.get('/:id/return', returnController.createReturn)

module.exports = router