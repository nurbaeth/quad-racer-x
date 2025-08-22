# 🏁 QuadRacerX – Onchain ATV Racing Game     
       
**QuadRacerX** is a fully onchain multiplayer ATV (quad bike) racing game built in Solidity.        
Players register, join races, and make moves turn by turn to reach the finish line.     
The first one to cross the finish line wins. Simple, fun, and trustless.       
    
---    
   
## ⚙️ Features    
     
- 🏎️ **Register & Race**: Players join open races with their wallets.    
- 🧠 **Turn-Based Logic**: Choose your speed (1–10) per move.    
- 🏁 **Win Condition**: First player to reach 100 units wins the race.      
- 📜 **Onchain Gameplay**: Every move and result is recorded on Ethereum-compatible chains.   
- 🔒 **No Admins**: All logic is transparent and immutable.     
  
---  
 
## 📦 Smart Contract  
 
- Language: Solidity `^0.8.20`  
- Contract: `QuadRacerX.sol`  
- No dependencies (pure Solidity)  
- Ready for deployment on testnets like Sepolia or local chains like Hardhat 

---

## 🚀 How to Play (Developer Mode)

1. **Deploy the contract**
2. **Create race**:
   ```solidity
   createRace()
