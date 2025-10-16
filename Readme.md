#  FocusToken — On-Chain Productivity & Focus Tracker

**FocusToken (FCT)** is a decentralized productivity tracking contract that rewards users with ERC-20-style tokens based on their **focus sessions**.  
Each session logs duration and timestamp on-chain, while users are ranked globally through a **leaderboard system**.  

---

##  Features

-  **ERC-20 Token Mechanics**
  - Mint, transfer, approve, and burn tokens.
  - Admin-controlled minting for verified sessions.

- ⏱ **Focus Session Recording**
  - Records session duration and timestamp per user.
  - Rewards tokens proportional to focus time.

-  **Pagination Support**
  - Efficient retrieval of user session history in batches.

- **Leaderboard**
  - Ranks users by total focus time.
  - Uses an on-chain sorting mechanism (bubble sort for demonstration).

- **Token Burn Mechanism**
  - 1% of each transfer is burned to maintain token scarcity.

---

##  Contract Breakdown

| Component | Purpose |
|------------|----------|
| `_balances`, `_allowance` | Manage token ownership and approvals. |
| `_sessions` | Store all user focus sessions. |
| `totalTime` | Track total focus time per user. |
| `_users` | List of unique participants for leaderboard sorting. |
| `recordFocus()` | Core admin function to log sessions and mint tokens. |
| `getLeaderboard()` | Returns a ranked, paginated leaderboard. |

---

## Tokenomics

| Parameter | Value |
|------------|--------|
| Token Name | FocusToken |
| Symbol | FCT |
| Decimals | 18 |
| Mint Policy | Admin-only minting during verified sessions |
| Burn Rate | 1% per transfer |

---

## How It Works

1. **Admin logs a focus session** using `recordFocus(address user, uint256 durationMinutes)`.
2. The function mints `durationMinutes * 10^18` tokens to the user.
3. Each session (duration, timestamp) is stored for future lookup.
4. Total focus time per user is updated.
5. `getLeaderboard()` returns users ranked by total focus time.

---

##  Example Use Case

A productivity app or DAO where:
- Members track their focused work sessions.
- Smart contracts mint FocusTokens as proof of effort.
- Leaderboards showcase the most consistent and productive members.
- Tokens could later be exchanged for perks, DAO votes, or NFTs.

---

##  Security Highlights

- `onlyAdmin` modifier ensures only the admin can log focus sessions.
- Safe checks for valid addresses and durations.
- Burn and transfer mechanics prevent inflation.

---

## Future Enhancements

- Replace bubble sort with off-chain sorting or `heap sort` for scalability.  
- Introduce **staking** to reward long-term holders.  
- Add **NFT badges** for milestone achievements.  
- Integrate **ETH rewards** for top performers.

---

##  Educational Focus

This contract is perfect for demonstrating:
- ERC-20 fundamentals
- Structs, mappings, and dynamic arrays
- Custom modifiers
- Event emission and tracking
- On-chain pagination and leaderboard logic

---

##  Deployment Steps

1. Deploy `FocusToken` using Remix or Hardhat.
2. Call `recordFocus(user, duration)` as admin to simulate productivity sessions.
3. Retrieve session data with `getUserSession()`.
4. Check rankings via `getLeaderboard()`.

---

## License
MIT License — feel free to fork, modify, and expand this project.

---

## Author
Created by Yonas Birhanu — exploring blockchain, gamified productivity, and decentralized motivation systems.
