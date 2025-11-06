import { useState } from 'react'
import Header from './components/header'
import Footer from './components/footer'
import Home from '../page/home'

function App() {
  const [count, setCount] = useState(0)

  return (
    <>
      <h1>hello</h1>
     <Header/>
     <Footer/>
     <Home/>
    </>
  )
}

export default App
