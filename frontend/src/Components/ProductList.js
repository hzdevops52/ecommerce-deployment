import { useEffect, useState } from "react"
import { useNavigate } from "react-router"
import Alert from "./Alert"
import Search from "./Search"
import { useAlert } from "../AlertContext"

export default function ProductList() {
    const [products, setProducts] = useState([])
    const { showAlert } = useAlert()
    const navigate = useNavigate()

    useEffect(() => {
        fetch(`${process.env.REACT_APP_BACKEND_URL}/products`, {
            method: "GET",
            credentials: "include",
            headers: {
                "Content-type": "application/json",
            }
        }).then((res) => {
            return res.json()
        }).then((data) => {
            setProducts(data)
        }).catch((err) => {
            console.log(err)
        })
    }, [])

    const addToCart = (product) => {
        fetch(`${process.env.REACT_APP_BACKEND_URL}/cart`, {
            method: "POST",
            credentials: "include",
            headers: {
                "Content-type": "application/json",
            },
            body: JSON.stringify({
                cartItem: [{
                    image: product.image,
                    name: product.name,
                    price: product.price,
                    description: product.description
                }]
            })
        }).then((res) => {
            return res.json()
        }).then((data) => {
            showAlert(data[0], data[1])
        }).catch((err) => {
            showAlert("Error", "Failed to add item to cart")
            console.log(err)
        })
    }

    return (
        <div className="min-h-[calc(100vh-60px)] bg-gradient-to-br from-gray-950 via-gray-900 to-gray-800 text-white overflow-y-auto">

            <section className="w-full px-6 pt-10 pb-6 text-center">
                <h1 className="text-4xl md:text-5xl font-bold tracking-tight mb-3">
                    Discover something great
                </h1>

                <p className="text-gray-400 text-base md:text-lg max-w-2xl mx-auto">
                    Explore our products and find something that fits what you're looking for.
                </p>

                <div className="mt-6">
                    <Search />
                </div>
            </section>

            <section className="px-6 pb-10">
                <div className="grid grid-cols-1 sm:grid-cols-2 lg:grid-cols-3 gap-6 max-w-6xl mx-auto">

                    {products.map((product, index) => (
                        <div
                            className="bg-white/10 backdrop-blur-md border border-white/10 p-5 rounded-2xl shadow-lg hover:bg-white/15 transition duration-200"
                            key={index}
                        >
                            <img
                                src={product.image}
                                height={200}
                                width={200}
                                className="w-full h-52 object-contain rounded-xl cursor-pointer bg-white/5"
                                onClick={() => {
                                    navigate(`/${product._id}`)
                                }}
                            />

                            <div className="mt-5">
                                <h3 className="text-xl font-semibold text-white">
                                    {product.name}
                                </h3>

                                <p className="mt-2 text-gray-300">
                                    Price: ₹{product.price}
                                </p>

                                <button
                                    className="mt-4 w-full py-2.5 rounded-xl bg-white text-gray-900 font-semibold hover:bg-gray-200 transition duration-200"
                                    onClick={() => {
                                        addToCart(product)
                                    }}
                                >
                                    Add to Cart
                                </button>

                                <button
                                    className="mt-3 w-full py-2.5 rounded-xl bg-gray-700 text-white font-semibold hover:bg-gray-600 transition duration-200"
                                >
                                    Buy Now
                                </button>
                            </div>
                        </div>
                    ))}

                </div>
            </section>

            <footer className="text-center py-6 border-t border-white/10">
                <p className="text-sm text-gray-500">
                    © GitHub · hzdevops52
                </p>
            </footer>

            {alert.length > 0 &&
                <Alert
                    heading={alert[0]}
                    message={alert[1]}
                    onClose={() => {
                        showAlert("", "")
                    }}
                />
            }

        </div>
    )
}