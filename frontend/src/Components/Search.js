import Alert from "./Alert"
import { useAlert } from "../AlertContext"
import { SearchContext } from "../SearchContext"
import { useNavigate } from "react-router-dom"
import { useState, useContext } from "react"

export default function Search() {
    const [input, setInput] = useState("")
    const { setRes } = useContext(SearchContext)
    const navigate = useNavigate()
    const { showAlert } = useAlert()

    const handleSearch = () => {
        navigate("/searchProducts")

        if (input === "" || input === null) {
            showAlert(["Error", "Cannot search for an empty input"])
        } else {
            fetch(`${process.env.REACT_APP_BACKEND_URL}/searchProducts`, {
                method: "POST",
                credentials: "include",
                headers: {
                    "Content-type": "application/json",
                },
                body: JSON.stringify({
                    search: input
                })
            }).then((res) => {
                return res.json()
            }).then((data) => {
                if (data === "" || data === null || data === undefined) {
                    showAlert("Error", "No products found")
                } else {
                    setRes(data)
                    setInput("")
                }
            })
        }
    }

    return (
        <div className="w-full flex justify-center px-4 py-6">
            <div className="w-full max-w-2xl flex items-center gap-3">
                <input
                    type="search"
                    placeholder="Search for products..."
                    onChange={(e) => { setInput(e.target.value) }}
                    className="flex-1 h-12 px-5 rounded-xl border border-gray-300 bg-white text-gray-900 placeholder-gray-400 shadow-sm outline-none transition focus:border-gray-500 focus:ring-2 focus:ring-gray-200"
                />

                <button
                    onClick={handleSearch}
                    className="h-12 px-7 rounded-xl bg-gray-900 text-white font-medium shadow-sm transition hover:bg-gray-700 active:scale-95"
                >
                    Search
                </button>
            </div>

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