module NQB.Network (test) where

import Data.ByteString (ByteString)
import GHC.Generics (Generic)
import Network.Socket (Family (..), SockAddr (..), Socket, SocketType (..), accept, bind, close, connect, defaultProtocol, listen, socket, tupleToHostAddress, tupleToHostAddress6)
import Network.Socket.ByteString (recv, sendAll)

import Control.Monad (zipWithM_)
import Data.Foldable (traverse_)

import GHC.Stack

test :: (HasCallStack) => IO ()
test = do
  servers <- traverse (uncurry openServer) [(st, addr) | st <- testTypes, addr <- addrTypes]
  clients <- traverse (uncurry openClient) [(st, addr) | st <- testTypes, addr <- addrTypes]
  zipWithM_ (\s1 s2 -> communicate s1 s2 ["hello"]) clients servers
testTypes :: [SocketType]
testTypes = [Stream, Datagram, Raw]

addrTypes :: [AddrType]
addrTypes = enumFromTo minBound maxBound

data AddrType = AddrINet | AddrINet6 | AddrUnix
  deriving (Eq, Ord, Show, Enum, Bounded, Generic)

addrForType :: AddrType -> SockAddr
addrForType = \case
  AddrINet -> SockAddrInet 3000 $ tupleToHostAddress (127, 0, 0, 1)
  AddrINet6 -> SockAddrInet6 3001 0 (tupleToHostAddress6 (0, 0, 0, 0, 0, 0, 0, 1)) 0
  AddrUnix -> SockAddrUnix "testnetwork"

familyForType :: AddrType -> Family
familyForType = \case
  AddrINet -> AF_INET
  AddrINet6 -> AF_INET6
  AddrUnix -> AF_RAW

openClient :: (HasCallStack) => SocketType -> AddrType -> IO Socket
openClient st addrt = do
  c <- socket (familyForType addrt) st defaultProtocol
  connect c $ addrForType addrt
  pure c

openServer :: (HasCallStack) => SocketType -> AddrType -> IO Socket
openServer st addrt = do
  s <- socket (familyForType addrt) st defaultProtocol
  bind s $ addrForType addrt
  listen s 1
  pure s

communicate ::
  (HasCallStack) =>
  -- | client
  Socket ->
  -- | server
  Socket ->
  -- | messages
  [ByteString] ->
  IO ()
communicate sc ss messages = do
  (sss, _) <- accept ss
  traverse_ (sendAll sc) messages
  out <- recvAll sss
  traverse_ print out

recvAll :: (HasCallStack) => Socket -> IO [ByteString]
recvAll sock = do
  ms <- recv sock 4096
  if ms /= ""
    then do
      mss <- recvAll sock
      pure $ ms : mss
    else pure []
