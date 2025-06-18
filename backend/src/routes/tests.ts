import { Router } from 'express';

const router = Router();

router.get('/', (req, res) => {
  res.json({ message: 'Get tests endpoint' });
});

router.get('/:id', (req, res) => {
  res.json({ message: `Get test ${req.params.id} endpoint` });
});

router.post('/', (req, res) => {
  res.json({ message: 'Create test endpoint' });
});

export default router;
