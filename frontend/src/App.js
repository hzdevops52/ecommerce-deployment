import { Link, Route, Routes } from "react-router"
import Register from "./Components/SignUp"
import Authorize from "./Components/Login"
import ProductForm from "./Components/ProductForm"
import ProductList from "./Components/ProductList"
import Cart from "./Components/Cart"
import Result from "./Components/Results"
import AlertWrapper from "./Components/AlertWrapper"
import Detail from "./Components/ProductInfo"

export default function App(){
    return (
        <div className="overflow-y-hidden h-[100vh]">
            <AlertWrapper />

            <div className="sticky top-0 z-100 h-[60px] px-8 w-full bg-black/90 backdrop-blur-md text-white flex items-center justify-between shadow-lg border-b border-white/10">

                <Link to="/">
                    <button className="px-5 py-2 rounded-lg font-semibold tracking-wide hover:bg-white/10 transition duration-200">
                        Home
                    </button>
                </Link>

                <Link to="/auth">
                    <button className="px-5 py-2 rounded-lg font-semibold tracking-wide hover:bg-white/10 transition duration-200">
                        Sign Up
                    </button>
                </Link>

                <Link to="/verify">
                    <button className="px-5 py-2 rounded-lg font-semibold tracking-wide hover:bg-white/10 transition duration-200">
                        Log In
                    </button>
                </Link>

                <Link to="/products">
                    <button className="px-5 py-2 rounded-lg font-semibold tracking-wide hover:bg-white/10 transition duration-200">
                        Add Product
                    </button>
                </Link>

                <Link to="/cart">
                    <button className="px-5 py-2 rounded-lg font-semibold tracking-wide hover:bg-white/10 transition duration-200">
                        Cart
                    </button>
                </Link>

            </div>

            <Routes>
                <Route path="/auth" element={<Register/>}/>
                <Route path="/verify" element={<Authorize/>}/>
                <Route path="/products" element={<ProductForm/>}/>
                <Route path="/" element={<ProductList/>}/>
                <Route path="/cart" element={<Cart/>}/>
                <Route path="/searchProducts" element={<Result/>}/>
                <Route path="/:id" element={<Detail/>}/>
            </Routes>
        </div>
    )
}