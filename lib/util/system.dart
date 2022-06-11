import 'package:suzuki/main.dart' as main;
import 'package:suzuki/util/data.dart';

class System {
  static Data get data {
    return main.data;
  }

  // static final SystemStream stream = new SystemStream(main.data);

  static void commit() {
    // stream.stateSink.add(data);
    main.data.commit();
  }
}
