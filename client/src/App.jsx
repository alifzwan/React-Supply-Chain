
import "./app.scss";
import { BrowserRouter as Router, Routes, Route } from "react-router-dom";

import Home from "./components/home/Home"
import Project from "./components/showcase/project/Project";
import Blockchain from "./components/showcase/blockchain/Blockchain";
import ProjectHero from "./components/showcase/project/projectHero/ProjectHero";
import Register from "./components/showcase/register/Register";
import Order from "./components/showcase/order/Order";
import HalalVerify from "./components/showcase/halalverify/HalalVerify";
import SlaughterVerify from "./components/showcase/slaughterverify/SlaughterVerify";
import Admin from "./components/showcase/admin/Admin";
import Track from "./components/showcase/track/Track";
import Info from "./components/showcase/info/Info";
import Login from "./components/showcase/login/Login";


const App = () => {
  return (
    <>
    <Router>
    <Routes>
          <Route path = '/' exact element={<Home />}/>
          <Route path = '/project' exact  element={<Project />} />
          <Route path = '/blockchain' exact  element={<Blockchain />} />
          <Route path = '/projecthero' exact  element={<ProjectHero />} />
          <Route path = '/login' exact  element={<Login />} />
          <Route path = '/register' exact  element={<Register />} />
          <Route path = '/order' exact  element={<Order />} />
          <Route path = '/slaughterhouse' exact  element={<SlaughterVerify />} />
          <Route path = '/verify' exact  element={<HalalVerify />} />
          <Route path = '/admin' exact  element={<Admin />} />
          <Route path = '/track' exact  element={<Track />} />
          <Route path = '/info' exact  element={<Info />} />
        </Routes>
    </Router>
    </>
    
  );
};

export default App;
