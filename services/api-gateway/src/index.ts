import express from 'express';
import { createProxyMiddleware } from 'http-proxy-middleware';
import rateLimit from 'express-rate-limit';
import helmet from 'helmet';
import cors from 'cors';
import pino from 'pino';

const logger = pino({ level: 'info' });
const app = express();

app.use(helmet());
app.use(cors());
app.use(express.json());

// Rate limiting
const limiter = rateLimit({
  windowMs: 15 * 60 * 1000,
  max: 100,
  message: 'Too many requests from this IP',
});
app.use(limiter);

// Service URLs
const USER_SERVICE = process.env.USER_SERVICE_URL || 'http://localhost:3001';
const PRODUCT_SERVICE = process.env.PRODUCT_SERVICE_URL || 'http://localhost:3002';
const ORDER_SERVICE = process.env.ORDER_SERVICE_URL || 'http://localhost:3003';

// Health check
app.get('/health', (req, res) => {
  res.json({ status: 'healthy', service: 'api-gateway' });
});

// Proxy routes
app.use('/api/users', createProxyMiddleware({
  target: USER_SERVICE,
  changeOrigin: true,
  onProxyReq: (proxyReq, req, res) => {
    logger.info({ path: req.path, service: 'user-service' }, 'Proxying request');
  },
}));

app.use('/api/products', createProxyMiddleware({
  target: PRODUCT_SERVICE,
  changeOrigin: true,
  onProxyReq: (proxyReq, req, res) => {
    logger.info({ path: req.path, service: 'product-service' }, 'Proxying request');
  },
}));

app.use('/api/orders', createProxyMiddleware({
  target: ORDER_SERVICE,
  changeOrigin: true,
  onProxyReq: (proxyReq, req, res) => {
    logger.info({ path: req.path, service: 'order-service' }, 'Proxying request');
  },
}));

const PORT = process.env.PORT || 3000;
app.listen(PORT, () => {
  logger.info({ port: PORT }, 'API Gateway started');
});
