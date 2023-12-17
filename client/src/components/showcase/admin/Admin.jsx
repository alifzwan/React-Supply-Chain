import "./admin.scss";
import { motion } from "framer-motion";
import { useNavigate } from "react-router-dom"
import React, { useState, useEffect } from 'react'
import Web3 from "web3";
import "ldrs/cardio"; 
import ProjectSideBar from '../project/projectsidebar/projectSideBar/ProjectSideBar';
import SupplyChainABI from "/src/artifacts/SupplyChain.json"



const variants = {
    open: {
        transition: {
            staggerChildren: 0.1,
        },
    },
    closed: {
        transition: {
            staggerChildren: 0.05,
            staggerDirection: 0,
        },
    },
};
const itemVariants = {
    open: {
        y: 0,
        opacity: 1,
    },
    closed: {
        y: 50,
        opacity: 0,
    },
};



const Admin = () => {

    const navigate = useNavigate()


    useEffect(() => {
        loadWeb3();
    }, [])

    useEffect(() =>{
        const delay = 2000;
        const timeoutId = setTimeout(() => {
            loadBlockchaindata();
        }, delay);
         return () => clearTimeout(timeoutId);
    }, []);

    const [currentaccount, setCurrentaccount] = useState("");
    const [loader        , setloader]         = useState(true);
    const [SupplyChain   , setSupplyChain]    = useState();
    const [Items         , setItems]          = useState();
    const [ItemPhase     , setItemPhase]      = useState();
    const [ItemID        , setItemID]         = useState();


    const loadWeb3 = async () => {
        if (window.ethereum) {
            window.web3 = new Web3(window.ethereum);
            await window.ethereum.eth_requestAccounts;
        } else if (window.web3) {
            window.web3 = new Web3(window.web3.currentProvider);
        } else {
            window.alert(
                "Non-Ethereum browser detected. You should consider trying MetaMask!"
            );
        }
    };

    const loadBlockchaindata = async () => {
        setloader(true);
        const web3 = window.web3;
        const accounts = await web3.eth.getAccounts();
        const account = accounts[0];
        setCurrentaccount(account);
        const networkId = await web3.eth.net.getId();
        const networkData = SupplyChainABI.networks[networkId];
        if (networkData) {
            const supplychain = new web3.eth.Contract(SupplyChainABI.abi, networkData.address);
            setSupplyChain(supplychain);
            var i;
            const itemsCount = await supplychain.methods.itemsCount().call();
            const item = {};
            const ItemPhase = [];
            for (i = 0; i < itemsCount; i++) {
                item[i] = await supplychain.methods.ItemsInfo(i + 1).call();
                ItemPhase[i] = await supplychain.methods.Chronology(i + 1).call();
            }
            setItems(item);
            setItemPhase(ItemPhase);
            setloader(false);
        }
        else {
            window.alert('The smart contract is not deployed to current network')
        }
    }


    if (loader) {
        return (
            <div className="loader" style={{ fontFamily: 'system-ui, sans-serif', lineHeight: '1.8' }}>
                <h1>Food Supply Chain System</h1>
                <l-cardio color="white" size="50" stroke="4" speed="2"></l-cardio>   
            </div>
        )
    }

    const redirect_to_project = () => {
      navigate('/project')
    }

    const adminID = (event) => {
        setItemID(event.target.value);
    }

    const adminFarmer = async (event) => {
        event.preventDefault();
        try {
            var receipt = await SupplyChain.methods.Farmering(ItemID).send({ from: currentaccount });
            if (receipt) {
                await loadBlockchaindata();
            }
        }
        catch (err) {
            alert("An error occured!!!")
        }
    }

    const adminVerifier = async (event) => {
        event.preventDefault();
        try {
            var receipt = await SupplyChain.methods.Verifying(ItemID).send({ from: currentaccount });
            if (receipt) {
                await loadBlockchaindata();
            }
        }
        catch (err) {
            alert("An error occured!!!")
        }
    }
    
    
    const adminManufacture = async (event) => {
        event.preventDefault();
        try {
            var receipt = await SupplyChain.methods.Manufacturing(ItemID).send({ from: currentaccount });
            if (receipt) {
                await loadBlockchaindata();
            }
        }
        catch (err) {
            alert("An error occured!!!")
        }
    }


    const adminDistribute = async (event) => {
        event.preventDefault();
        try {
            var receipt = await SupplyChain.methods.Distributing(ItemID).send({ from: currentaccount });
            if (receipt) {
                await loadBlockchaindata();
            }
        }
        catch (err) {
            alert("An error occured!!!")
        }
    }


    const adminRetail = async (event) => {
        event.preventDefault();
        try {
            var receipt = await SupplyChain.methods.Retailing(ItemID).send({ from: currentaccount });
            if (receipt) {
                await loadBlockchaindata();
            }
        }
        catch (err) {
            alert("An error occured!!!")
        }
    }


    const adminSold = async (event) => {
        event.preventDefault();
        try {
            var receipt = await SupplyChain.methods.sold(ItemID).send({ from: currentaccount });
            if (receipt) {
                await loadBlockchaindata();
            }
        }
        catch (err) {
            alert("An error occured!!!")
        }
    }


    return(
    <div className="admin-main-container">

        <div className="menu-bar">
            <ProjectSideBar />
        </div> 

        <div className="main-section">
            <div className="admin-section-title">Administration</div>
                <div className="admin-content">
                    <table className="table-container" border="1">
                        <thead>
                            <tr>
                                <th>ID</th>
                                <th>Name</th>
                                <th>Categories</th>
                                <th>Brand</th>
                                <th>Based In</th>
                                <th>Description</th>
                                <th>Current Stage</th>
                            </tr>
                        </thead>
                        <tbody>
                            {Object.keys(Items).map(function (key) {
                                return (
                                    <tr key={key}>
                                        <td>{Number(Items[key].id)}</td>
                                        <td>{Items[key].name}</td>
                                        <td>{Items[key].categories}</td>
                                        <td>{Items[key].brand}</td>
                                        <td>{Items[key].origin}</td>
                                        <td>{Items[key].nutritionInfo}</td>
                                        <td>
                                            {
                                                ItemPhase[key]
                                            }
                                        </td>
                                    </tr>
                                )
                            })}
                        </tbody>
                    </table>

                    <div className="admin-grid">
                        <div className="admin-section">
                            <h2>Farmer</h2>
                                <form onSubmit={adminFarmer}>
                                    <motion.div className="input-container" variants={variants}>

                                        <motion.div variants={itemVariants}>
                                            <input type="text" onChange={adminID} placeholder="Enter ID" required/><br />
                                        </motion.div>

                                    <motion.div variants={itemVariants} className="admin-button">
                                        <motion.button
                                            variants={itemVariants}
                                            whileHover={{ scale: 1.1 }}
                                            whileTap={{ scale: 0.95 }}
                                            onSubmit={adminFarmer}
                                        >
                                            Punch In
                                        </motion.button>
                                    </motion.div>
                                
                                    </motion.div>
                                </form>
                        </div>

                        <div className="admin-section">
                            <h2>Verifier</h2>
                                <form onSubmit={adminVerifier}>
                                    <motion.div className="input-container" variants={variants}>

                                        <motion.div variants={itemVariants}>
                                            <input type="text" onChange={adminID} placeholder="Enter ID" required/><br />
                                        </motion.div>

                                    <motion.div variants={itemVariants} className="admin-button">
                                        <motion.button
                                            variants={itemVariants}
                                            whileHover={{ scale: 1.1 }}
                                            whileTap={{ scale: 0.95 }}
                                            onSubmit={adminVerifier}
                                        >
                                            Punch In
                                        </motion.button>
                                    </motion.div>
                                
                                    </motion.div>
                                </form>
                        </div>

                        <div className="admin-section">
                            <h2>Slaughterhouse</h2>
                                <form >
                                    <motion.div className="input-container" variants={variants}>

                                        <motion.div variants={itemVariants}>
                                            <input type="text"  placeholder="Enter ID" /><br />
                                        </motion.div>

                                    <motion.div variants={itemVariants} className="admin-button">
                                        <motion.button
                                            variants={itemVariants}
                                            whileHover={{ scale: 1.1 }}
                                            whileTap={{ scale: 0.95 }}
                                            
                                        >
                                            Punch In
                                        </motion.button>
                                    </motion.div>
                                
                                    </motion.div>
                                </form>
                        </div>

                        <div className="admin-section">
                            <h2>Manufacturer</h2>
                                <form onSubmit={adminManufacture}>

                                    <motion.div className="input-container" variants={variants}>
                                        <motion.div variants={itemVariants}>
                                            <input type="text"  onChange={adminID} placeholder="Enter ID" required/><br />
                                        </motion.div>

                                    <motion.div variants={itemVariants} className="admin-button">
                                        <motion.button
                                            variants={itemVariants}
                                            whileHover={{ scale: 1.1 }}
                                            whileTap={{ scale: 0.95 }}
                                            onSubmit={adminManufacture}
                                        >
                                            Punch In
                                        </motion.button>
                                    </motion.div>
                                
                                    </motion.div>
                                </form>
                            
                        </div>
                        

                        <div className="admin-section">
                            <h2>Distributor</h2>
                                <form onSubmit={adminDistribute}>
                                    <motion.div className="input-container" variants={variants}>
                                    <motion.div variants={itemVariants}>
                                        <input type="text" onChange={adminID} placeholder="Enter ID" required/><br />
                                    </motion.div>

                                    <motion.div variants={itemVariants} className="admin-button">
                                        <motion.button
                                            variants={itemVariants}
                                            whileHover={{ scale: 1.1 }}
                                            whileTap={{ scale: 0.95 }}
                                            onSubmit={adminDistribute}
                                        >
                                            Punch In
                                        </motion.button>
                                    </motion.div>
                                
                                </motion.div>
                                </form>
                                
                        </div>

                        <div className="admin-section">
                            <h2>Retailer</h2>
                                <form onSubmit={adminRetail}>
                                    <motion.div className="input-container" variants={variants}>
                                    <motion.div variants={itemVariants}>
                                        <input type="text" onChange={adminID} placeholder="Enter ID" required/><br />
                                    </motion.div>

                                    <motion.div variants={itemVariants} className="admin-button">
                                        <motion.button
                                            variants={itemVariants}
                                            whileHover={{ scale: 1.1 }}
                                            whileTap={{ scale: 0.95 }}
                                            onSubmit={adminRetail}
                                        >
                                            Punch In
                                        </motion.button>
                                    </motion.div>
                                
                                </motion.div>
                                </form>
                        </div>
                    </div>

                    <div className="admin-sold-section">
                        <h2>Sold</h2>
                            <form onSubmit={adminSold}>
                                <motion.div className="input-container" variants={variants}>
                                    <motion.div variants={itemVariants}>
                                        <input type="text" onChange={adminID} placeholder="Enter ID" required/><br />
                                    </motion.div>

                                    <motion.div variants={itemVariants} className="admin-button">
                                        <motion.button
                                            variants={itemVariants}
                                            whileHover={{ scale: 1.1 }}
                                            whileTap={{ scale: 0.95 }}
                                            onSubmit={adminSold}
                                        >
                                            Punch In
                                        </motion.button>
                                    </motion.div>
                            
                                </motion.div>
                            </form>
                        
                    </div>

                    <div className="admin-back-button-container">
                        <motion.div variants={itemVariants} className="admin-back-button">
                            <motion.button
                                variants={itemVariants}
                                whileHover={{ scale: 1.1 }}
                                whileTap={{ scale: 0.95 }}
                                onClick={redirect_to_project}
                            >
                                Back to Project 
                            </motion.button>
                        </motion.div>
                    </div>
            </div>
        </div>

           
               
                
                
                

            
            


           
                
    </div>       
    )
}
    
export default Admin