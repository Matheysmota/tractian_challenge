const baseUrl = String.fromEnvironment('BASE_URL',
    defaultValue: 'fake-api.tractian.com');
const connectTimeout =
    int.fromEnvironment('CONNECT_TIMEOUT', defaultValue: 5000);
const receiveTimeout =
    int.fromEnvironment('RECEIVE_TIMEOUT', defaultValue: 5000);
