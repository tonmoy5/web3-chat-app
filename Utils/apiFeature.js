import { ethers } from "ethers";
import web3Modal from "web3modal";

import { ChatAppAddress, ChatAppABI } from "../Context/constants";


export const CheckIfWalletConnected = async () => {
  try {
    if (!window.ethereum) return console.log("Install Metamask");

    const accounts = await window.ethereum.request({
      method: "eth_accounts",
    });
    const firstAccount = accounts[0];
    return firstAccount;
  } catch (err) {
    console.log("Install Metamask To Continue", err);
  }
}

export const connectWallet = async () => {
  try {
    if (!window.ethereum) return console.log("Install Metamask");

    const accounts = await window.ethereum.request({
      method: "eth_requestAccounts",
    });
    const firstAccount = accounts[0];
    return firstAccount;
  } catch (err) {
    console.log(err)
  }
}


const fetchContract = (signerOrProvider) => new ethers.Contract(ChatAppABI, ChatAppAddress, signerOrProvider);

export const connectingWithContract = async () => {
  try {
    const web3Modal = new web3Modal();
    const connection = await web3Modal.connect();
    const provider = new ethers.providers.Web3Provider(connection);
    const signer = provider.getSigner();
    const contract = fetchContract(signer);

    return contract;
  } catch (err) {
    console.log(err)
  }
}



export const convertTime = (time) => {
  const newTime = new Date(time.toNumber());

  const realTime = newTime.getHours() + "/" + newTime.getMinutes() + "/" + newTime.getSecond() + " Date:" + newTime.getDate() + "/" + (newTime.getMonth() + 1) + "/" + newTime.getFullYear();

  return realTime;
}