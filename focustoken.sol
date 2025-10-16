
// SPDX-License-Identifier: MIT
pragma solidity ^0.8.17;

contract FocusToken{
    // state variables 
    
    uint256 private _totalSupply;
    address private _admin;
    mapping(address=>uint256) private _balances;
    mapping(address=>mapping(address=>uint256)) private _allowance;
    address[] private _users;

    struct focussession{
        uint256 duration;
        uint256 timeStamp;
    }

    mapping(address=>focussession[]) private _sessions;

    mapping(address=>bool) private _isuser;
    mapping(address=>uint256) private totalTime;


    // Meta-data functions

    function  name() public pure returns(string memory){
        return "FocusToken";}

    function symbol() public pure returns(string memory){return "FCT";}

    function decimals() public pure returns(uint8){return 18;}


    constructor(){
        _admin=msg.sender;}

    // modifier

    modifier onlyAdmin{
      require(msg.sender==_admin,"admin access required");_;}
    

// events 

event Transfer(address indexed _from, address indexed _to, uint256 _amount);
event Approval(address indexed _owner, address indexed spender, uint256 _amount);
event FocusCompleted(address indexed _user,uint256 _duration, uint256 reward);

// core functions 

function totalSupply() public view returns(uint256){
    return _totalSupply;
}

function balanceOf(address _account) public view returns(uint256){
    return _balances[_account];
}

function allowance(address _owner, address _spender) public view returns(uint256){
    return _allowance[_owner][_spender];
}

function transfer(address _to, uint256 _amount) public returns (bool){
    require(_to!=address(0),"invalid address");
    require(_amount>0,"invalid amount");
    require(_balances[msg.sender]>=_amount,"insufficient balance");
    uint256 burnAmount =_amount/100;
    uint256 transferAmount=_amount-burnAmount;
    require(_balances[msg.sender]>=_amount,"insufficient balance");
    _balances[msg.sender]-=_amount;
    _balances[_to]+=transferAmount;
    _totalSupply-=burnAmount;
    emit Transfer(msg.sender,_to,transferAmount);
    emit Transfer(msg.sender,address(0),burnAmount);
    return true;
}

function transferFrom(address _from, address _to , uint256 _amount) public returns(bool){

require(_to!=address(0),"invalid address");
require(_allowance[_from][msg.sender]>=_amount,"insufficient allowance");
require(_balances[_from]>=_amount,"insufficient balance");
_allowance[_from][msg.sender]-=_amount;
_balances[_from]-=_amount;
_balances[_to]+=_amount;
emit Transfer(_from,_to,_amount);
return true;

}

function approve(address spender,uint256 _amount) public returns(bool){
require(spender!=address(0),"invalid address");
_allowance[msg.sender][spender]=_amount;
emit Approval(msg.sender,spender,_amount);
return true;

}
function mintToken(address _to , uint256 _amount) public onlyAdmin returns(bool){
    require(_to!=address(0),"invalid address");
    _balances[_to]+=_amount;
    _totalSupply+=_amount;
    emit Transfer(address(0),_to,_amount);
    return true;
}


// now we will go for the pagiantion and loop one!

function recordFocus(address _user,uint256 durationMinutes) public onlyAdmin{
    require(_user!=address(0),"invalid address");
    require(durationMinutes>0 && durationMinutes<480,"invalid duration!");

    uint256 _reward=durationMinutes*(10**decimals());
    _sessions[_user].push(focussession(durationMinutes,block.timestamp));
    totalTime[_user]+=durationMinutes;

    // now check if the user already exists in the map
    if(!_isuser[_user]){
        _isuser[_user]=true;
        _users.push(_user);

    }
     mintToken(_user,_reward);
    emit FocusCompleted(_user, durationMinutes, _reward);
}

//now we paginate and return the duration and time stamp of the user

function getUserSession(address user,uint256 start, uint256 end) public view returns(focussession[] memory ){

require(end<=_sessions[user].length && start<end,"invalid range!");
uint256 length=end-start;

focussession[] memory page=new focussession[](length);

for(uint256 i=0;i<length;i++){
    page[i]=_sessions[user][start+i];
    
    }
return page;

}






function totalFocusTime(address _user) public view returns(uint256){
   require(_user!=address(0),"invalid address!");
   return totalTime[_user];    
}


// now we will use loop and return the leader-board. here we have to use sorting algorithm. 
function getLeaderboard(uint256 start, uint256 end) public view returns(address[] memory,uint256[] memory){
    require(end<=_users.length && start<end,"invalid range!");
    uint256 length=end-start;
    address[] memory leaderboard=new address[](length);
    uint256[] memory focustime=new uint256[](length);

    address[] memory temp=_users;
    uint256 totallen=temp.length;

// sort it first using bubble sort algorithm
    for(uint256 i=0;i<totallen;i++){
        for(uint256 j=i+1;j<totallen;j++){
            if(totalFocusTime(temp[i])<totalFocusTime(temp[j])){
                (temp[i],temp[j])=(temp[j],temp[i]);
        }
    }  
}


// now it is the time to return our result but here it must be pagenated!

for(uint256 i=0;i<length;i++){
    leaderboard[i]=temp[start+i];
    focustime[i]=totalFocusTime(temp[start + i]);
}
return(leaderboard,focustime);
}


}

