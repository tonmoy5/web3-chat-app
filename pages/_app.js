import '../styles/globals.css'
import { ChatAppProvider } from '../Context/ChatAppCountext'
import { NavBar } from "../Components/index"

const MyApp = ({ Component, pageProps }) => {
  <div>
    <ChatAppProvider>
      <NavBar />
      <Component {...pageProps} />
    </ChatAppProvider>
  </div>
}

export default MyApp
