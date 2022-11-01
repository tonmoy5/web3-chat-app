import React, { useEffect, useState, useContext } from 'react'

import { ChatAppContext } from '../Context/ChatAppCountext'

const ChapApp = () => {
  const { title } = useContext(ChatAppContext);
  return (
    <div>{title}</div>
  )
}

export default ChapApp