// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.4;

 interface Erc20Interface{
    function totalSupply () external view returns(uint);
    function balanceOf (address tokenOwner) external view returns (uint balance);
    function transfer(address to, uint tokens) external returns (bool success);

    function allowance(address tokenOwner, address spender) external view returns (uint remaining);
    function approve(address spender, uint tokens) external returns (bool success);
    function transferFrom(address from, address to, uint tokens) external returns (bool success);
    
    event Transfer(address indexed from, address indexed to, uint tokens);
    event Approval(address indexed tokenOwner, address indexed spender, uint tokens);
 }
 
  
contract Hashira is Erc20Interface{
     string public name = "Hashira";
     string public symbol = "HRA";
     string public decimal = "0";

     uint public override totalSupply;
     address public owner;
     mapping(address=>uint) public balances;
     mapping(address=>mapping(address=>uint)) allowed;

     modifier onlyOwner(){
         require(msg.sender==owner);
         _;
     }

     constructor(){
         totalSupply= 10000;
         owner = msg.sender;
         balances[owner]=totalSupply;
         
         
     }

     function balanceOf(address tokenOwner) public view override returns(uint balance){
         return balances[tokenOwner];
     }
       

       // to transfer tokens and check if sender has exact amount of tokens available
     function transfer (address to, uint tokens) public  override returns(bool success){
         require(balances[msg.sender]>=tokens);
         balances[to]+=tokens; //balances[to]=balances[to]+tokens;
         balances[msg.sender]-=tokens;
         emit Transfer(msg.sender,to,tokens);
         return true;
     }

     function approve(address spender, uint tokens) public override returns(bool success){
         require(balances[msg.sender]>=tokens);
         require(tokens>0);
         allowed[msg.sender][spender]=tokens;
         emit Approval(msg.sender,spender,tokens);
         return true;

     }

     function allowance(address tokenOwner, address spender) public view override returns( uint noOfTokens){
         return allowed[tokenOwner][spender];
     }

     function transferFrom(address from, address to, uint tokens) public override returns(bool success){
        require(allowed[from][to]>=tokens);
        require(balances[from]>=tokens);
        balances[from]-=tokens;
        balances[to]+=tokens;
        return true;
     }

     // function to change ownership

     function ChangeOwnership(address _owner) public onlyOwner {
         owner = _owner;
     }


     // function to burn and decrease total supply


    function _burn(address from, uint tokens) internal {
    require(from != address(0), "Cant burn from a null address");
    require(balances[from] >= tokens, "Cant burn 0 tokens");

       // Remove the amount from the account balance
         balances[from] = balances[from] - tokens;
        // Decrease totalSupply
            totalSupply = totalSupply - tokens;
         // Emit event, use zero address as reciever
          emit Transfer(from, address(0), tokens);

    }

    function burn(address account, uint256 amount) public onlyOwner returns(bool) {
       _burn(account, amount);
       return true;
   }

   


     

     
     


 }


 


