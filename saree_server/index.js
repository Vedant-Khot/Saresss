const express = require('express');
const cors = require('cors');
const multer = require('multer');
const fs = require('fs');
const path = require('path');
const dotenv = require('dotenv');
const cloudinary = require('cloudinary').v2;

dotenv.config();

// Configure Cloudinary
cloudinary.config({
    cloud_name: process.env.CLOUDINARY_CLOUD_NAME,
    api_key: process.env.CLOUDINARY_API_KEY,
    api_secret: process.env.CLOUDINARY_API_SECRET
});

const app = express();
const PORT = process.env.PORT || 5000;

// Middleware
app.use(cors());
app.use(express.json());
app.use('/uploads', express.static(path.join(__dirname, 'uploads')));

// Storage setup for Multer (Temporarily store before Cloudinary)
const storage = multer.diskStorage({
    destination: (req, file, cb) => {
        const dir = './uploads';
        if (!fs.existsSync(dir)){
            fs.mkdirSync(dir);
        }
        cb(null, dir);
    },
    filename: (req, file, cb) => {
        cb(null, Date.now() + path.extname(file.originalname));
    }
});

const upload = multer({ storage: storage });

// Database utility (Phase 1)
const DB_PATH = path.join(__dirname, 'data.json');

const readDB = () => {
    try {
        if (!fs.existsSync(DB_PATH)) return { sarees: [] };
        const data = fs.readFileSync(DB_PATH, 'utf8');
        return JSON.parse(data);
    } catch (err) {
        return { sarees: [] };
    }
};

const writeDB = (data) => {
    fs.writeFileSync(DB_PATH, JSON.stringify(data, null, 2));
};

// --- Routes ---

// Get all sarees
app.get('/api/sarees', (req, res) => {
    const db = readDB();
    res.json(db.sarees);
});

// Upload new saree (TO CLOUDINARY)
app.post('/api/sarees', upload.single('image'), async (req, res) => {
    const { name, price, fabric, color, stock, category } = req.body;
    const db = readDB();

    try {
        let imageUrl = null;
        
        if (req.file) {
            // Upload to Cloudinary
            const result = await cloudinary.uploader.upload(req.file.path, {
                folder: 'saree_catalog'
            });
            imageUrl = result.secure_url;
            
            // Delete local temp file
            fs.unlinkSync(req.file.path);
        }

        const newSaree = {
            id: Date.now().toString(),
            name,
            price,
            fabric,
            color,
            stock,
            category,
            image: imageUrl, // Now a global Cloudinary URL
            createdAt: new Date().toISOString()
        };

        db.sarees.push(newSaree);
        writeDB(db);

        res.status(201).json(newSaree);
    } catch (error) {
        console.error('Upload Error:', error);
        res.status(500).json({ error: 'Failed to upload to Cloudinary' });
    }
});

// Health check
app.get('/', (req, res) => {
    res.send('SareeStream API is running (Cloud-Ready)...');
});

app.listen(PORT, '0.0.0.0', () => {
    console.log(`Server running on port ${PORT}`);
});

