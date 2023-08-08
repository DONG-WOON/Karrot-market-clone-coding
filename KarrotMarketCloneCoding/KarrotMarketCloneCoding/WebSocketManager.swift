//
//  WebSocketManager.swift
//  KarrotMarketCloneCoding
//
//  Created by 서동운 on 7/16/23.
//

import Foundation
import StompClientLib

enum WebSocketError: Error {
    case invalidURL
}

final class WebSocketManager {
    static let shared = WebSocketManager()
    private var socketClient: StompClientLib
    private let url = URL(string: "")!
    var isConnect: Bool {
        socketClient.isConnected()
    }
    
    private init() {
        socketClient = StompClientLib()
    }
    
    func connect() {
        if socketClient.isConnected() {
            socketClient.disconnect()
        }
        socketClient.openSocketWithURLRequest(request: NSURLRequest(url: url) , delegate: self)
    }
    
    func sendMessage(_ message: String, opponentEmail: String, myEmail: String) {
        if socketClient.isConnected() {
            socketClient.sendMessage(message: message, toDestination: "/app/chat/\(opponentEmail)/\(myEmail)", withHeaders: ["email": "\(myEmail)"], withReceipt: nil)
        } else {
            print("error: socket is not connect")
        }
    }
    
    func subscribe(opponentEmail: String, myEmail: String) {
        socketClient.subscribe(destination: "/queue/messages/\(opponentEmail)/\(myEmail)")
    }
}

extension WebSocketManager: StompClientLibDelegate {
    func stompClientDidConnect(client: StompClientLib) {
    }
    
    func stompClient(client: StompClientLib, didReceiveMessageWithJSONBody jsonBody: AnyObject?, akaStringBody stringBody: String?, withHeader header: [String : String]?, withDestination destination: String) {
        print(#function,"🔥")
    }
    
    func stompClientDidDisconnect(client: StompClientLib) {
        print(#function,"🔥")
    }
    
    func serverDidSendReceipt(client: StompClientLib, withReceiptId receiptId: String) {
        print(#function,"🔥")
    }
    
    func serverDidSendError(client: StompClientLib, withErrorMessage description: String, detailedErrorMessage message: String?) {
        print(#function,"🔥")
    }
    
    func serverDidSendPing() {
        print(#function,"🔥")
    }
}

