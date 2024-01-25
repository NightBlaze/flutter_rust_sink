// This file is automatically generated, so please do not edit it.
// Generated by `flutter_rust_bridge`@ 2.0.0-dev.20.

// ignore_for_file: unused_import, unused_element, unnecessary_import, duplicate_ignore, invalid_use_of_internal_member, annotate_overrides, non_constant_identifier_names, curly_braces_in_flow_control_structures, prefer_const_literals_to_create_immutables, unused_field

import 'api/actors/actors_manager.dart';
import 'api/actors/color_box_actor.dart';
import 'api/simple.dart';
import 'dart:async';
import 'dart:convert';
import 'frb_generated.io.dart' if (dart.library.html) 'frb_generated.web.dart';
import 'package:flutter_rust_bridge/flutter_rust_bridge_for_generated.dart';

/// Main entrypoint of the Rust API
class RustLib extends BaseEntrypoint<RustLibApi, RustLibApiImpl, RustLibWire> {
  @internal
  static final instance = RustLib._();

  RustLib._();

  /// Initialize flutter_rust_bridge
  static Future<void> init({
    RustLibApi? api,
    BaseHandler? handler,
    ExternalLibrary? externalLibrary,
  }) async {
    await instance.initImpl(
      api: api,
      handler: handler,
      externalLibrary: externalLibrary,
    );
  }

  /// Dispose flutter_rust_bridge
  ///
  /// The call to this function is optional, since flutter_rust_bridge (and everything else)
  /// is automatically disposed when the app stops.
  static void dispose() => instance.disposeImpl();

  @override
  ApiImplConstructor<RustLibApiImpl, RustLibWire> get apiImplConstructor =>
      RustLibApiImpl.new;

  @override
  WireConstructor<RustLibWire> get wireConstructor =>
      RustLibWire.fromExternalLibrary;

  @override
  Future<void> executeRustInitializers() async {
    await api.initApp();
  }

  @override
  ExternalLibraryLoaderConfig get defaultExternalLibraryLoaderConfig =>
      kDefaultExternalLibraryLoaderConfig;

  @override
  String get codegenVersion => '2.0.0-dev.20';

  static const kDefaultExternalLibraryLoaderConfig =
      ExternalLibraryLoaderConfig(
    stem: 'rust_lib',
    ioDirectory: 'rust/target/release/',
    webPrefix: 'pkg/',
  );
}

abstract class RustLibApi extends BaseApi {
  int generateActorId({dynamic hint});

  String colorModelDescription({required ColorModel that, dynamic hint});

  Future<void> colorBoxCancelChangeColorSink(
      {required int actorId, dynamic hint});

  Future<ColorModel?> colorBoxChangeColor({required int actorId, dynamic hint});

  Stream<ColorModel> colorBoxChangeColorSink(
      {required int actorId, dynamic hint});

  Future<void> colorBoxDelete({required int actorId, dynamic hint});

  Future<String?> colorBoxLike({required int actorId, dynamic hint});

  Future<void> colorBoxNew({required int actorId, dynamic hint});

  String greet({required String name, dynamic hint});

  Future<void> initApp({dynamic hint});
}

class RustLibApiImpl extends RustLibApiImplPlatform implements RustLibApi {
  RustLibApiImpl({
    required super.handler,
    required super.wire,
    required super.generalizedFrbRustBinding,
    required super.portManager,
  });

  @override
  int generateActorId({dynamic hint}) {
    return handler.executeSync(SyncTask(
      callFfi: () {
        final serializer = SseSerializer(generalizedFrbRustBinding);
        return pdeCallFfi(generalizedFrbRustBinding, serializer, funcId: 1)!;
      },
      codec: SseCodec(
        decodeSuccessData: sse_decode_u_64,
        decodeErrorData: null,
      ),
      constMeta: kGenerateActorIdConstMeta,
      argValues: [],
      apiImpl: this,
      hint: hint,
    ));
  }

  TaskConstMeta get kGenerateActorIdConstMeta => const TaskConstMeta(
        debugName: "generate_actor_id",
        argNames: [],
      );

  @override
  String colorModelDescription({required ColorModel that, dynamic hint}) {
    return handler.executeSync(SyncTask(
      callFfi: () {
        final serializer = SseSerializer(generalizedFrbRustBinding);
        sse_encode_box_autoadd_color_model(that, serializer);
        return pdeCallFfi(generalizedFrbRustBinding, serializer, funcId: 8)!;
      },
      codec: SseCodec(
        decodeSuccessData: sse_decode_String,
        decodeErrorData: null,
      ),
      constMeta: kColorModelDescriptionConstMeta,
      argValues: [that],
      apiImpl: this,
      hint: hint,
    ));
  }

  TaskConstMeta get kColorModelDescriptionConstMeta => const TaskConstMeta(
        debugName: "ColorModel_description",
        argNames: ["that"],
      );

  @override
  Future<void> colorBoxCancelChangeColorSink(
      {required int actorId, dynamic hint}) {
    return handler.executeNormal(NormalTask(
      callFfi: (port_) {
        final serializer = SseSerializer(generalizedFrbRustBinding);
        sse_encode_u_64(actorId, serializer);
        pdeCallFfi(generalizedFrbRustBinding, serializer,
            funcId: 6, port: port_);
      },
      codec: SseCodec(
        decodeSuccessData: sse_decode_unit,
        decodeErrorData: null,
      ),
      constMeta: kColorBoxCancelChangeColorSinkConstMeta,
      argValues: [actorId],
      apiImpl: this,
      hint: hint,
    ));
  }

  TaskConstMeta get kColorBoxCancelChangeColorSinkConstMeta =>
      const TaskConstMeta(
        debugName: "color_box_cancel_change_color_sink",
        argNames: ["actorId"],
      );

  @override
  Future<ColorModel?> colorBoxChangeColor(
      {required int actorId, dynamic hint}) {
    return handler.executeNormal(NormalTask(
      callFfi: (port_) {
        final serializer = SseSerializer(generalizedFrbRustBinding);
        sse_encode_u_64(actorId, serializer);
        pdeCallFfi(generalizedFrbRustBinding, serializer,
            funcId: 4, port: port_);
      },
      codec: SseCodec(
        decodeSuccessData: sse_decode_opt_box_autoadd_color_model,
        decodeErrorData: null,
      ),
      constMeta: kColorBoxChangeColorConstMeta,
      argValues: [actorId],
      apiImpl: this,
      hint: hint,
    ));
  }

  TaskConstMeta get kColorBoxChangeColorConstMeta => const TaskConstMeta(
        debugName: "color_box_change_color",
        argNames: ["actorId"],
      );

  @override
  Stream<ColorModel> colorBoxChangeColorSink(
      {required int actorId, dynamic hint}) {
    return handler.executeStream(StreamTask(
      callFfi: (port_) {
        final serializer = SseSerializer(generalizedFrbRustBinding);
        sse_encode_u_64(actorId, serializer);
        pdeCallFfi(generalizedFrbRustBinding, serializer,
            funcId: 5, port: port_);
      },
      codec: SseCodec(
        decodeSuccessData: sse_decode_color_model,
        decodeErrorData: null,
      ),
      constMeta: kColorBoxChangeColorSinkConstMeta,
      argValues: [actorId],
      apiImpl: this,
      hint: hint,
    ));
  }

  TaskConstMeta get kColorBoxChangeColorSinkConstMeta => const TaskConstMeta(
        debugName: "color_box_change_color_sink",
        argNames: ["actorId"],
      );

  @override
  Future<void> colorBoxDelete({required int actorId, dynamic hint}) {
    return handler.executeNormal(NormalTask(
      callFfi: (port_) {
        final serializer = SseSerializer(generalizedFrbRustBinding);
        sse_encode_u_64(actorId, serializer);
        pdeCallFfi(generalizedFrbRustBinding, serializer,
            funcId: 3, port: port_);
      },
      codec: SseCodec(
        decodeSuccessData: sse_decode_unit,
        decodeErrorData: null,
      ),
      constMeta: kColorBoxDeleteConstMeta,
      argValues: [actorId],
      apiImpl: this,
      hint: hint,
    ));
  }

  TaskConstMeta get kColorBoxDeleteConstMeta => const TaskConstMeta(
        debugName: "color_box_delete",
        argNames: ["actorId"],
      );

  @override
  Future<String?> colorBoxLike({required int actorId, dynamic hint}) {
    return handler.executeNormal(NormalTask(
      callFfi: (port_) {
        final serializer = SseSerializer(generalizedFrbRustBinding);
        sse_encode_u_64(actorId, serializer);
        pdeCallFfi(generalizedFrbRustBinding, serializer,
            funcId: 7, port: port_);
      },
      codec: SseCodec(
        decodeSuccessData: sse_decode_opt_String,
        decodeErrorData: null,
      ),
      constMeta: kColorBoxLikeConstMeta,
      argValues: [actorId],
      apiImpl: this,
      hint: hint,
    ));
  }

  TaskConstMeta get kColorBoxLikeConstMeta => const TaskConstMeta(
        debugName: "color_box_like",
        argNames: ["actorId"],
      );

  @override
  Future<void> colorBoxNew({required int actorId, dynamic hint}) {
    return handler.executeNormal(NormalTask(
      callFfi: (port_) {
        final serializer = SseSerializer(generalizedFrbRustBinding);
        sse_encode_u_64(actorId, serializer);
        pdeCallFfi(generalizedFrbRustBinding, serializer,
            funcId: 2, port: port_);
      },
      codec: SseCodec(
        decodeSuccessData: sse_decode_unit,
        decodeErrorData: null,
      ),
      constMeta: kColorBoxNewConstMeta,
      argValues: [actorId],
      apiImpl: this,
      hint: hint,
    ));
  }

  TaskConstMeta get kColorBoxNewConstMeta => const TaskConstMeta(
        debugName: "color_box_new",
        argNames: ["actorId"],
      );

  @override
  String greet({required String name, dynamic hint}) {
    return handler.executeSync(SyncTask(
      callFfi: () {
        final serializer = SseSerializer(generalizedFrbRustBinding);
        sse_encode_String(name, serializer);
        return pdeCallFfi(generalizedFrbRustBinding, serializer, funcId: 9)!;
      },
      codec: SseCodec(
        decodeSuccessData: sse_decode_String,
        decodeErrorData: null,
      ),
      constMeta: kGreetConstMeta,
      argValues: [name],
      apiImpl: this,
      hint: hint,
    ));
  }

  TaskConstMeta get kGreetConstMeta => const TaskConstMeta(
        debugName: "greet",
        argNames: ["name"],
      );

  @override
  Future<void> initApp({dynamic hint}) {
    return handler.executeNormal(NormalTask(
      callFfi: (port_) {
        final serializer = SseSerializer(generalizedFrbRustBinding);
        pdeCallFfi(generalizedFrbRustBinding, serializer,
            funcId: 10, port: port_);
      },
      codec: SseCodec(
        decodeSuccessData: sse_decode_unit,
        decodeErrorData: null,
      ),
      constMeta: kInitAppConstMeta,
      argValues: [],
      apiImpl: this,
      hint: hint,
    ));
  }

  TaskConstMeta get kInitAppConstMeta => const TaskConstMeta(
        debugName: "init_app",
        argNames: [],
      );

  @protected
  String dco_decode_String(dynamic raw) {
    // Codec=Dco (DartCObject based), see doc to use other codecs
    return raw as String;
  }

  @protected
  ColorModel dco_decode_box_autoadd_color_model(dynamic raw) {
    // Codec=Dco (DartCObject based), see doc to use other codecs
    return dco_decode_color_model(raw);
  }

  @protected
  ColorModel dco_decode_color_model(dynamic raw) {
    // Codec=Dco (DartCObject based), see doc to use other codecs
    final arr = raw as List<dynamic>;
    if (arr.length != 3)
      throw Exception('unexpected arr length: expect 3 but see ${arr.length}');
    return ColorModel(
      red: dco_decode_u_8(arr[0]),
      green: dco_decode_u_8(arr[1]),
      blue: dco_decode_u_8(arr[2]),
    );
  }

  @protected
  Uint8List dco_decode_list_prim_u_8_strict(dynamic raw) {
    // Codec=Dco (DartCObject based), see doc to use other codecs
    return raw as Uint8List;
  }

  @protected
  String? dco_decode_opt_String(dynamic raw) {
    // Codec=Dco (DartCObject based), see doc to use other codecs
    return raw == null ? null : dco_decode_String(raw);
  }

  @protected
  ColorModel? dco_decode_opt_box_autoadd_color_model(dynamic raw) {
    // Codec=Dco (DartCObject based), see doc to use other codecs
    return raw == null ? null : dco_decode_box_autoadd_color_model(raw);
  }

  @protected
  int dco_decode_u_64(dynamic raw) {
    // Codec=Dco (DartCObject based), see doc to use other codecs
    return dcoDecodeI64OrU64(raw);
  }

  @protected
  int dco_decode_u_8(dynamic raw) {
    // Codec=Dco (DartCObject based), see doc to use other codecs
    return raw as int;
  }

  @protected
  void dco_decode_unit(dynamic raw) {
    // Codec=Dco (DartCObject based), see doc to use other codecs
    return;
  }

  @protected
  String sse_decode_String(SseDeserializer deserializer) {
    // Codec=Sse (Serialization based), see doc to use other codecs
    var inner = sse_decode_list_prim_u_8_strict(deserializer);
    return utf8.decoder.convert(inner);
  }

  @protected
  ColorModel sse_decode_box_autoadd_color_model(SseDeserializer deserializer) {
    // Codec=Sse (Serialization based), see doc to use other codecs
    return (sse_decode_color_model(deserializer));
  }

  @protected
  ColorModel sse_decode_color_model(SseDeserializer deserializer) {
    // Codec=Sse (Serialization based), see doc to use other codecs
    var var_red = sse_decode_u_8(deserializer);
    var var_green = sse_decode_u_8(deserializer);
    var var_blue = sse_decode_u_8(deserializer);
    return ColorModel(red: var_red, green: var_green, blue: var_blue);
  }

  @protected
  Uint8List sse_decode_list_prim_u_8_strict(SseDeserializer deserializer) {
    // Codec=Sse (Serialization based), see doc to use other codecs
    var len_ = sse_decode_i_32(deserializer);
    return deserializer.buffer.getUint8List(len_);
  }

  @protected
  String? sse_decode_opt_String(SseDeserializer deserializer) {
    // Codec=Sse (Serialization based), see doc to use other codecs

    if (sse_decode_bool(deserializer)) {
      return (sse_decode_String(deserializer));
    } else {
      return null;
    }
  }

  @protected
  ColorModel? sse_decode_opt_box_autoadd_color_model(
      SseDeserializer deserializer) {
    // Codec=Sse (Serialization based), see doc to use other codecs

    if (sse_decode_bool(deserializer)) {
      return (sse_decode_box_autoadd_color_model(deserializer));
    } else {
      return null;
    }
  }

  @protected
  int sse_decode_u_64(SseDeserializer deserializer) {
    // Codec=Sse (Serialization based), see doc to use other codecs
    return deserializer.buffer.getUint64();
  }

  @protected
  int sse_decode_u_8(SseDeserializer deserializer) {
    // Codec=Sse (Serialization based), see doc to use other codecs
    return deserializer.buffer.getUint8();
  }

  @protected
  void sse_decode_unit(SseDeserializer deserializer) {
    // Codec=Sse (Serialization based), see doc to use other codecs
  }

  @protected
  int sse_decode_i_32(SseDeserializer deserializer) {
    // Codec=Sse (Serialization based), see doc to use other codecs
    return deserializer.buffer.getInt32();
  }

  @protected
  bool sse_decode_bool(SseDeserializer deserializer) {
    // Codec=Sse (Serialization based), see doc to use other codecs
    return deserializer.buffer.getUint8() != 0;
  }

  @protected
  void sse_encode_String(String self, SseSerializer serializer) {
    // Codec=Sse (Serialization based), see doc to use other codecs
    sse_encode_list_prim_u_8_strict(utf8.encoder.convert(self), serializer);
  }

  @protected
  void sse_encode_box_autoadd_color_model(
      ColorModel self, SseSerializer serializer) {
    // Codec=Sse (Serialization based), see doc to use other codecs
    sse_encode_color_model(self, serializer);
  }

  @protected
  void sse_encode_color_model(ColorModel self, SseSerializer serializer) {
    // Codec=Sse (Serialization based), see doc to use other codecs
    sse_encode_u_8(self.red, serializer);
    sse_encode_u_8(self.green, serializer);
    sse_encode_u_8(self.blue, serializer);
  }

  @protected
  void sse_encode_list_prim_u_8_strict(
      Uint8List self, SseSerializer serializer) {
    // Codec=Sse (Serialization based), see doc to use other codecs
    sse_encode_i_32(self.length, serializer);
    serializer.buffer.putUint8List(self);
  }

  @protected
  void sse_encode_opt_String(String? self, SseSerializer serializer) {
    // Codec=Sse (Serialization based), see doc to use other codecs

    sse_encode_bool(self != null, serializer);
    if (self != null) {
      sse_encode_String(self, serializer);
    }
  }

  @protected
  void sse_encode_opt_box_autoadd_color_model(
      ColorModel? self, SseSerializer serializer) {
    // Codec=Sse (Serialization based), see doc to use other codecs

    sse_encode_bool(self != null, serializer);
    if (self != null) {
      sse_encode_box_autoadd_color_model(self, serializer);
    }
  }

  @protected
  void sse_encode_u_64(int self, SseSerializer serializer) {
    // Codec=Sse (Serialization based), see doc to use other codecs
    serializer.buffer.putUint64(self);
  }

  @protected
  void sse_encode_u_8(int self, SseSerializer serializer) {
    // Codec=Sse (Serialization based), see doc to use other codecs
    serializer.buffer.putUint8(self);
  }

  @protected
  void sse_encode_unit(void self, SseSerializer serializer) {
    // Codec=Sse (Serialization based), see doc to use other codecs
  }

  @protected
  void sse_encode_i_32(int self, SseSerializer serializer) {
    // Codec=Sse (Serialization based), see doc to use other codecs
    serializer.buffer.putInt32(self);
  }

  @protected
  void sse_encode_bool(bool self, SseSerializer serializer) {
    // Codec=Sse (Serialization based), see doc to use other codecs
    serializer.buffer.putUint8(self ? 1 : 0);
  }
}
