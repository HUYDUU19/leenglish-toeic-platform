import { Router } from 'express';

const router = Router();

router.get('/', (req, res) => {
  res.json({ message: 'Get users endpoint' });
});

router.get('/:id', (req, res) => {
  res.json({ message: `Get user ${req.params.id} endpoint` });
});

router.put('/:id', (req, res) => {
  res.json({ message: `Update user ${req.params.id} endpoint` });
});

export default router;