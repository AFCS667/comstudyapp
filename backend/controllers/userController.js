const User = require('../models/user');
const bycrypt = require('bcryptjs');

exports.loginUser = async (req, res) => {
    try {
        const { email, password } = req.body;

        const user = await User.findOne({ email });
        if (!user) {
            return res.status(404).json({ message: 'User not found' });
        }

        const isMatch = await bycrypt.compare(password, user.password);
        if(!isMatch){
            return res.status(401).json({ status: 'error', message: 'wrong password '})
        }

        res.status(200).json({
            status: 'success',
            message: 'Login successful',
            user: {id: user._id, name: user.name }
        });
    } catch (error) {
        res.status(500).json({ status: 'error', message: 'Server error' });
    }
}