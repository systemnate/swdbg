import { useState, useEffect } from 'react'
import './App.css'

function App() {
  const [stuff, setStuff] = useState([])
  const [loading, setLoading] = useState(true)
  const [error, setError] = useState(null)

  useEffect(() => {
    const fetchPosts = async () => {
      try {
        setLoading(true)
        const response = await fetch("/api/tests")

        if (!response.ok) {
          throw new Error(`HTTP error! Status: ${response.status}`)
        }

        const data = await response.json()
        console.log("data", data)
        setStuff(data)
        setLoading(false)
      } catch (error) {
        console.error('Error fetching tests:', error)
        setError('Failed to load tests. Please try again later.')
        setLoading(false)
      }
    }

    fetchPosts()
  }, [])

  if (loading) return <div>Loading tests...</div>
  if (error) return <div>Error: {error}</div>

    console.log("stuff", stuff)
    return (
      <div className="app">
      <h1>Data from Rails API</h1>

      {stuff.length === 0 ? (
        <p>No tests found.</p>
      ) : (
        <div className="tests">
        {stuff.map(s => (
          <div key={s.id} className="tests">
          <p>{s.value}</p>
          </div>
        ))}
        </div>
      )}
      </div>
    )
}

export default App
