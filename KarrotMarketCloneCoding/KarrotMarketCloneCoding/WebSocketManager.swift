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
    private var socketClient: StompClientLib
    private let url = URL(string: KarrotURL.socket)!
    
    init() {
        socketClient = StompClientLib()
    }
    
    func connect() {
        if socketClient.isConnected() {
            socketClient.disconnect()
        }
        
        socketClient.openSocketWithURLRequest(request: NSURLRequest(url: url) , delegate: self)
    }
    
    func disconnect() {
        socketClient.disconnect()
    }
    
    func sendMessage(_ message: String, opponentEmail: String, myEmail: String) {
        if socketClient.isConnected() {
            socketClient.sendMessage(message: message, toDestination: "/app/chat/\(myEmail)/\(opponentEmail)", withHeaders: ["email": "\(myEmail)"], withReceipt: nil)
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
        print(#function,"🔥")
    }
    
    
    func stompClient(client: StompClientLib, didReceiveMessageWithJSONBody jsonBody: AnyObject?, akaStringBody stringBody: String?, withHeader header: [String : String]?, withDestination destination: String) {
        if let data = stringBody?.data(using: String.Encoding.utf8) {
            let message = try? JSONDecoder().decode(Message.self, from: data)
            NotificationCenter.default.post(name: .receiveMessage, object: message)
        }
    }
    
    func stompClientDidDisconnect(client: StompClientLib) {
        print(#function,"🔥")
    }
    
    func serverDidSendReceipt(client: StompClientLib, withReceiptId receiptId: String) {
        print(client, receiptId)
    }
    
    func serverDidSendError(client: StompClientLib, withErrorMessage description: String, detailedErrorMessage message: String?) {
        print(client, description)
    }
    
    func serverDidSendPing() {
        print(#function,"🔥")
    }
}

