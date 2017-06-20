import BrightFutures
import Result

class GetPopularTracks {

    typealias Result = [Track]

    func performRequest() -> Future<Result, NoError> {

        let promise = Promise<Result, NoError>()

        let client = Client.SampleClient
        let session = Session(session: JsonAPISession(session: URLSession.shared,
                                                      clientInfo: JsonAPISession.ClientInfo(clientUuid: client.uuid,
                                                                                            appVersion: client.appVersion,
                                                                                            bundleName: client.bundleName,
                                                                                            deviceModel: client.deviceModel,
                                                                                            deviceSystemVersion: client.deviceSystemVersion)))

        session.perform(request: PopularRequest()).onSuccess { tracks in
            promise.success(tracks)
        }

        return promise.future
    }
}
