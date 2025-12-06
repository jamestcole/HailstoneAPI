def hailstone(n, step=0, max_steps=100):
    # Safety stop
    if step >= max_steps:
        return step, [n], False

    # Base case
    if n == 1:
        return step, [1], True

    # Compute next value
    next_n = n // 2 if n % 2 == 0 else 3 * n + 1

    # Recursive call
    steps, seq, finished = hailstone(next_n, step + 1, max_steps)

    # Build backward result
    return steps, [n] + seq, finished
