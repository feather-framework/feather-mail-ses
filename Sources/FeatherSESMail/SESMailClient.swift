//
//  SESMailClient.swift
//  feather-ses-mail
//
//  Created by gerp83 on 2025. 01. 16..
//

import FeatherMail
import SotoCore
import SotoSESv2
import Logging

/// A mail client implementation backed by Amazon SES.
///
/// `SESMailClient` is intended to be initialized once during server startup
/// and reused for the lifetime of the application. It validates mails,
/// encodes them into SES-compatible MIME messages, and delivers them using
/// the Amazon SES v2 API.
///
/// The client owns an underlying `AWSClient` and an `SESv2` client instance.
/// These resources are created during initialization and must be explicitly
/// shut down when the server stops.
public struct SESMailClient: MailClient, Sendable {

    /// Validator used to validate mails before sending.
    private let validator: MailValidator

    /// Encoder used to convert mails into raw MIME messages.
    private let encoder: any MailEncoder

    /// Amazon SES client used for mail delivery.
    private let ses: SESv2

    /// Underlying AWS client.
    private let client: AWSClient

    /// Logger used for Amazon SES operations.
    private let logger: Logger

    /// Creates a new Amazon SES mail client using an existing SES client.
    ///
    /// - Parameters:
    ///   - ses: A configured `SESv2` client instance.
    ///   - headerDate: Date header value provider used by the default encoder.
    ///   - validator: Validator applied before delivery.
    ///   - encoder: Encoder used to convert mails into raw MIME messages.
    ///   - logger: Logger used for SES request and transport logging.
    public init(
        ses: SESv2,
        headerDate: @escaping @Sendable () -> String,
        validator: MailValidator = BasicMailValidator(
            maxTotalAttachmentSize: 7_500_000
        ),
        encoder: (any MailEncoder)? = nil,
        logger: Logger = .init(label: "feather.mail.ses")
    ) {
        self.ses = ses
        self.client = ses.client
        self.validator = validator
        self.encoder =
            encoder
            ?? RawMailEncoder(
                headerDateEncodingStrategy: headerDate
            )
        self.logger = logger

    }

    /// Validates a mail using the configured validator.
    ///
    /// - Parameter mail: The mail to validate.
    /// - Throws: `MailValidationError` when validation fails.
    public func validate(_ mail: Mail) async throws(MailValidationError) {
        try await validator.validate(mail)
    }

    /// Sends a mail using Amazon SES.
    ///
    /// This method performs mail validation, MIME encoding, and delivery
    /// using the internally managed SES client. It does not create or
    /// tear down network resources.
    ///
    /// - Parameter mail: The mail to send.
    /// - Throws: `MailError` if validation, encoding, or delivery fails
    public func send(_ mail: Mail) async throws(MailError) {
        do {
            try await validate(mail)
        }
        catch {
            throw .validation(error)
        }

        let raw = try encoder.encode(mail: mail)
        let encodedData = Array(raw.utf8).base64EncodedString()

        let rawMessage = SESv2.RawMessage(
            data: AWSBase64Data.base64(encodedData)
        )
        let request = SESv2.SendEmailRequest(
            content: .init(
                raw: rawMessage
            )
        )

        do {
            //result is not used for now
            _ = try await ses.sendEmail(
                request,
                logger: logger
            )
        }
        catch {
            throw mapSESError(error)
        }
    }

    /// Maps Amazon SES errors to `MailError` values.
    private func mapSESError(_ error: Error) -> MailError {

        if let awsError = error as? AWSErrorType {
            return .custom("AWSErrorType - \(awsError.errorCode)")
        }

        return .unknown(error)
    }
}
