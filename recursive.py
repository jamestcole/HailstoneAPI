def hailstone(n, step=0):
    # print the initial sequence at the first step
    if step == 0:
        print(f"Hailstone sequence:")
    # print the current number (forward sequence print)
    print(n, end=" ")
    if step == 100:
        print('too many iterations , preventing looping')
        return step, [n], False
    # end if the value == 0 , base case
    if n == 1:
        print(f"\nBackward hailstone sequence")
        return step, [1], True
    # find the next value
    if n % 2 == 0:
        next_n = n // 2
    else:
        next_n = 3 * n + 1
    # recursive call , adding a step with each call
    steps, seq, finished= hailstone(next_n, step + 1)
    # print backwards 
    print(n, end=" ")
    # return the steps and sequence
    return steps, seq, finished
# run script using the input from the user
n = int(input("Number for hailstone: "))
# assign steps and sequence from calculating the halestone sequence
steps , sequence , finished = hailstone(n)
# print the result of when the hailstone was successful
# the final result message depends on whether recursion ended correctly limit set to 100
if finished:
    print(f"\n{n} transformed into 1 after {steps} iterations.")
else:
    print(f"\n{n} did not reach 1 — stopped at 100 iterations.")
