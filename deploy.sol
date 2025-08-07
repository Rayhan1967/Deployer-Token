// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

// Template Token Contract yang akan di-deploy
contract CustomToken {
    string public name;
    string public symbol;
    uint8 public decimals = 18;
    uint256 public totalSupply;
    address public owner;
    
    mapping(address => uint256) public balanceOf;
    mapping(address => mapping(address => uint256)) public allowance;
    
    event Transfer(address indexed from, address indexed to, uint256 value);
    event Approval(address indexed owner, address indexed spender, uint256 value);
    
    constructor(
        string memory _name,
        string memory _symbol,
        uint256 _totalSupply,
        address _owner
    ) {
        name = _name;
        symbol = _symbol;
        totalSupply = _totalSupply * 10**decimals;
        owner = _owner;
        balanceOf[_owner] = totalSupply;
        emit Transfer(address(0), _owner, totalSupply);
    }
    
    function transfer(address _to, uint256 _value) public returns (bool) {
        require(balanceOf[msg.sender] >= _value, "Insufficient balance");
        require(_to != address(0), "Invalid address");
        
        balanceOf[msg.sender] -= _value;
        balanceOf[_to] += _value;
        emit Transfer(msg.sender, _to, _value);
        return true;
    }
    
    function approve(address _spender, uint256 _value) public returns (bool) {
        allowance[msg.sender][_spender] = _value;
        emit Approval(msg.sender, _spender, _value);
        return true;
    }
    
    function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
        require(balanceOf[_from] >= _value, "Insufficient balance");
        require(allowance[_from][msg.sender] >= _value, "Allowance exceeded");
        require(_to != address(0), "Invalid address");
        
        balanceOf[_from] -= _value;
        balanceOf[_to] += _value;
        allowance[_from][msg.sender] -= _value;
        emit Transfer(_from, _to, _value);
        return true;
    }
}

// Factory Contract untuk Deploy Token
contract TokenDeployer {
    address public platformOwner;
    uint256 public deploymentFee = 0.001 ether; // Fee untuk deploy
    
    struct TokenInfo {
        address tokenAddress;
        string name;
        string symbol;
        uint256 totalSupply;
        address owner;
        uint256 deployedAt;
    }
    
    // Array semua token yang di-deploy
    TokenInfo[] public deployedTokens;
    
    // Mapping owner → token addresses
    mapping(address => address[]) public userTokens;
    
    // Events
    event TokenDeployed(
        address indexed tokenAddress,
        string name,
        string symbol,
        uint256 totalSupply,
        address indexed owner
    );
    
    constructor() {
        platformOwner = msg.sender;
    }
    
    // Function untuk deploy token baru
    function deployToken(
        string memory _name,
        string memory _symbol,
        uint256 _totalSupply
    ) public payable returns (address) {
        require(msg.value >= deploymentFee, "Insufficient deployment fee");
        require(bytes(_name).length > 0, "Name cannot be empty");
        require(bytes(_symbol).length > 0, "Symbol cannot be empty");
        require(_totalSupply > 0, "Total supply must be greater than 0");
        
        // Deploy token contract baru
        CustomToken newToken = new CustomToken(_name, _symbol, _totalSupply, msg.sender);
        address tokenAddress = address(newToken);
        
        // Simpan info token
        TokenInfo memory tokenInfo = TokenInfo({
            tokenAddress: tokenAddress,
            name: _name,
            symbol: _symbol,
            totalSupply: _totalSupply,
            owner: msg.sender,
            deployedAt: block.timestamp
        });
        
        deployedTokens.push(tokenInfo);
        userTokens[msg.sender].push(tokenAddress);
        
        emit TokenDeployed(tokenAddress, _name, _symbol, _totalSupply, msg.sender);
        
        return tokenAddress;
    }
    
    // Function untuk get total deployed tokens
    function getTotalDeployedTokens() public view returns (uint256) {
        return deployedTokens.length;
    }
    
    // Function untuk get user's tokens
    function getUserTokens(address _user) public view returns (address[] memory) {
        return userTokens[_user];
    }
    
    // Function untuk get token info by address
    function getTokenInfo(uint256 _index) public view returns (
        address tokenAddress,
        string memory name,
        string memory symbol,
        uint256 totalSupply,
        address owner,
        uint256 deployedAt
    ) {
        require(_index < deployedTokens.length, "Token not found");
        TokenInfo memory token = deployedTokens[_index];
        return (
            token.tokenAddress,
            token.name,
            token.symbol,
            token.totalSupply,
            token.owner,
            token.deployedAt
        );
    }
    
    // Function untuk update deployment fee (only platform owner)
    function updateDeploymentFee(uint256 _newFee) public {
        require(msg.sender == platformOwner, "Only platform owner");
        deploymentFee = _newFee;
    }
    
    // Function untuk withdraw fees (only platform owner)
    function withdrawFees() public {
        require(msg.sender == platformOwner, "Only platform owner");
        payable(platformOwner).transfer(address(this).balance);
    }
}