class AppConfig {
  // Server Configuration
  // Change this to your computer's IP address when running the backend server
  // To find your IP: run 'ipconfig' on Windows or 'ifconfig' on Mac/Linux
  static const String serverUrl = 'http://192.168.1.100:5000'; // Replace with your IP
  
  // Alternative configurations for different environments
  static const String localhostUrl = 'http://localhost:5000';
  static const String androidEmulatorUrl = 'http://10.0.2.2:5000';
  
  // App Settings
  static const String appName = 'Voice to Text';
  static const String version = '1.0.0';
  
  // Recording Settings
  static const int maxRecordingDuration = 300; // 5 minutes in seconds
  static const int minRecordingDuration = 1; // 1 second
  
  // File Settings
  static const List<String> supportedAudioFormats = [
    'mp3', 'wav', 'aac', 'm4a', 'ogg', 'flac'
  ];
  
  static const int maxFileSizeMB = 25; // 25 MB max file size
  
  // Get the appropriate server URL based on the platform
  static String getServerUrl() {
    // You can add logic here to automatically detect the environment
    // For now, return the configured server URL
    return serverUrl;
  }
  
  // Validate if a file extension is supported
  static bool isSupportedAudioFormat(String extension) {
    return supportedAudioFormats.contains(extension.toLowerCase().replaceAll('.', ''));
  }
}