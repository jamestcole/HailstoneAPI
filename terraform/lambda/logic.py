def hailstone(n, step=0, max_steps=10000):
    # Safety stop
    if step >= max_steps:
        return step, [n], False

    # Base case
    if n == 1:
        return step, [1], True

    # Compute next
    next_n = n // 2 if n % 2 == 0 else 3 * n + 1

    steps, seq, finished = hailstone(next_n, step + 1, max_steps)

    return steps, [n] + seq, finished
