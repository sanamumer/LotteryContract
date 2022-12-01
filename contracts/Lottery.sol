//SPDX-License-Identifier:UNLICENSED

pragma solidity 0.8.17;
import "@openzeppelin/contracts/utils/Counters.sol";
import "@openzeppelin/contracts/utils/math/SafeMath.sol";
import "@chainlink/contracts/src/v0.8/VRFV2WrapperConsumerBase.sol";
import "@chainlink/contracts/src/v0.8/ConfirmedOwner.sol";


contract LotteryGame is VRFV2WrapperConsumerBase,ConfirmedOwner{
    using Counters for Counters.Counter;
    using SafeMath for uint256;

    struct Lottery{
         uint256 lotteryId;
         address [] participants;
         address winner;
         bool isFinished;
 }  
    Counters.Counter private lotteryId;
    mapping(uint256 => Lottery) private lotteries;
    mapping(uint256 => uint256) private lotteryRandomnessRequest;
    mapping(uint256 => uint256) playersCount;
    address private admin;

    address linkAddress = 0x326C977E6efc84E512bB9C30f76E30c160eD06FB;
    address wrapperAddress = 0x708701a1DfF4f478de54383E49a627eD4852C816;
     uint32 callbackGasLimit = 100000;
     uint16 requestConfirmations = 3;
     uint32 numWords = 1;
    
    event LotteryCreated(uint256);
    event RandomnessRequested(uint256,uint256);
    event WinnerDeclared(uint256,uint256,address);

    constructor()
        ConfirmedOwner(msg.sender)
        VRFV2WrapperConsumerBase(linkAddress, wrapperAddress)
    {}
    
    modifier onlyAdmin {
     require(msg.sender == admin, "Only admin can call this function");
     _;
    }

   function createLottery() payable public onlyAdmin {
   
    Lottery memory lottery = Lottery({lotteryId: lotteryId.current(),
    participants: new address[](0),
    winner: address(0),
    isFinished: false});
    lotteries[lotteryId.current()] = lottery;
    lotteryId.increment();
    emit LotteryCreated(lottery.lotteryId);
    }

    function participate(uint256 _lotteryId) public payable {
        Lottery storage lottery = lotteries[_lotteryId];
        require(msg.value >= 0.01 ether,'INVALID AMOUNT!!');
        lottery.participants.push(msg.sender);   
    }

    function declareWinner(uint256 _lotteryId) public onlyAdmin {
        Lottery storage lottery = lotteries[_lotteryId];
        require(!lottery.isFinished,"Lottery has already declared a winner");
        uint256 requestId = requestRandomness(
            callbackGasLimit,
            requestConfirmations,
            numWords
        );
         lotteryRandomnessRequest[requestId] = _lotteryId;
         emit RandomnessRequested(requestId,_lotteryId);
        
    }

    function fulfillRandomWords(uint256 requestId, uint256[] memory _randomWords)internal override 
    {
        uint256 _lotteryId = lotteryRandomnessRequest[requestId];
        Lottery storage lottery = lotteries[_lotteryId];
        uint256 winner = _randomWords[0].mod(lottery.participants.length);
        lottery.isFinished = true;
        lottery.winner = lottery.participants[winner];
        payable(lottery.winner).transfer(address(this).balance);
        emit WinnerDeclared(requestId,lottery.lotteryId,lottery.winner);
    }

}