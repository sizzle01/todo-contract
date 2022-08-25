//SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract TodoContract{
     
    event AddTask(address recipient, uint taskId);
    event DeleteTask(uint taskId, bool isDeleted);

     struct Task {
        uint id;
        address username;
        string taskText;
        bool isDeleted;
    }
     
      Task[] public tasks;

      // mapping of task id to address
      mapping(uint256 => address) taskToOwner;

       function addTask(string memory taskText, bool isDeleted) external {
        uint taskId = tasks.length;
        tasks.push(Task(taskId, msg.sender, taskText, isDeleted));
        taskToOwner[taskId] = msg.sender;
        emit AddTask(msg.sender, taskId);
    }
  
    // Function to get list of todo items
    function getMyTasks() external view returns (Task[] memory) {
        Task[] memory temporary = new Task[](tasks.length);
        uint counter = 0;
        for(uint i=0; i<tasks.length; i++) {
            if(taskToOwner[i] == msg.sender && tasks[i].isDeleted == false) {
                temporary[counter] = tasks[i];
                counter++;
            }
        }
       Task[] memory result = new Task[](counter);
        for(uint i=0; i<counter; i++) {
            result[i] = temporary[i];
        }
        return result;
    }
    

    // function to Delete a Tweet
    function deleteTask(uint taskId, bool isDeleted) external {
        if(taskToOwner[taskId] == msg.sender) {
            tasks[taskId].isDeleted = isDeleted;
            emit DeleteTask(taskId, isDeleted);
        }
    }
}