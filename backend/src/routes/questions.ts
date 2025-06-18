import { Router } from 'express';

const router = Router();

router.get('/', (req, res) => {
  res.json({ message: 'Get questions endpoint' });
});

router.get('/:id', (req, res) => {
  res.json({ message: `Get question ${req.params.id} endpoint` });
});

router.post('/', (req, res) => {
  res.json({ message: 'Create question endpoint' });
});

export default router;

