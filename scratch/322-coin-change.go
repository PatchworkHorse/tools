func coinChange(coins []int, amount int) int {

    if amount < 0 {
        return -1
    }
    if amount == 0 {
        return 0
    }
    if len(coins) == 0 {
        return -1
    }

	// Array denoting the current min number of coins needed for each ..amount
	dp := make([]int, amount+1)

	// We don't need change for 0 amount
	dp[0] = 0

	// Init our dp table with some high value
	for i := 1; i <= amount; i++ {
		dp[i] = math.MaxInt
	}

	for i := 1; i <= amount; i++ {
		// For each value 1..amount, calculate the min coins needed to produce that value
		for _, c := range coins {
			if c <= i && dp[i-c] != math.MaxInt {
				dp[i] = min(dp[i], dp[i-c]+1)
			}
		}
	}

	if dp[amount] == math.MaxInt {
		return -1
	}

	return dp[amount]
}
