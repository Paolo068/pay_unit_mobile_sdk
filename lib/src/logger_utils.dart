import 'package:pusher_channels_flutter/pusher-js/core/logger.dart';

final logger = Logger.fakeConstructor$();

logError(String msg) {
  logger.error(msg.toString());
}

logInfo(String msg) {
  logger.debug(msg.toString());
}
