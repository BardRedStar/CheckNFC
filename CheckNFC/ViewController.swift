//
//  ViewController.swift
//  CheckNFC
//
//  Created by Denis Kovalev on 18.05.2020.
//  Copyright © 2020 Denis Kovalev. All rights reserved.
//

import UIKit
import CoreNFC

class ViewController: UIViewController {
    // MARK: - Outlets

    @IBOutlet private var textLabel: UILabel!

    // MARK: - Properties and variables

    private var nfcSession: NFCNDEFReaderSession?

    // MARK: - UI Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    // MARK: - UI Callbacks

    @IBAction private func checkNFCAction(_ sender: Any) {
        nfcSession = NFCNDEFReaderSession(delegate: self, queue: nil, invalidateAfterFirstRead: true)
        nfcSession?.begin()
    }
}

extension ViewController: NFCNDEFReaderSessionDelegate {
    func readerSession(_ session: NFCNDEFReaderSession, didInvalidateWithError error: Error) {
        DispatchQueue.main.async { [weak self] in
            self?.textLabel.text = error.localizedDescription
        }
    }

    func readerSession(_ session: NFCNDEFReaderSession, didDetectNDEFs messages: [NFCNDEFMessage]) {
        let message = messages.compactMap { String(data: $0.records.first?.payload.advanced(by: 3) ?? Data(), encoding: .utf8) }
            .joined(separator: "\n")

        DispatchQueue.main.async { [weak self] in
            self?.textLabel.text = message
        }
    }


}
