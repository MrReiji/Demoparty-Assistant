import 'package:flutter_form_bloc/flutter_form_bloc.dart';
import 'package:demoparty_assistant/data/services/cache_service.dart';
import 'package:demoparty_assistant/data/services/settings_service.dart';

/// CacheSettingsFormBloc manages form logic for cache-related settings.
class CacheSettingsFormBloc extends FormBloc<String, String> {
  /// Field for cache TTL (time-to-live) in seconds.
  final TextFieldBloc cacheTTL = TextFieldBloc(
    validators: [
      FieldBlocValidators.required,
      _numberValidator,
    ],
  );

  /// Field for enabling or disabling cache.
  final BooleanFieldBloc useCache = BooleanFieldBloc();

  final CacheService _cacheService;
  final SettingsService _settingsService;

  /// Constructor with dependency injection of CacheService and SettingsService.
  CacheSettingsFormBloc(this._cacheService, this._settingsService) {
    print("[CacheSettingsFormBloc] Initializing CacheSettingsFormBloc.");
    addFieldBlocs(fieldBlocs: [cacheTTL, useCache]);
    _loadInitialValues();
  }

  /// Loads initial values for cache TTL and the cache enable setting.
  Future<void> _loadInitialValues() async {
    print("[CacheSettingsFormBloc] Loading initial values for cache settings.");
    try {
      final currentTTL = await _cacheService.getCurrentTTL();
      final isCacheEnabled = await _settingsService.isCacheEnabled();
      cacheTTL.updateInitialValue(currentTTL.toString());
      useCache.updateInitialValue(isCacheEnabled);
      print("[CacheSettingsFormBloc] Initial values loaded: TTL=$currentTTL, CacheEnabled=$isCacheEnabled.");
    } catch (e) {
      print("[CacheSettingsFormBloc] Error loading initial values: $e");
    }
  }

  /// Updates cache settings (TTL and enable/disable state).
  @override
  Future<void> onSubmitting() async {
    emitSubmitting();
    try {
      final ttl = int.parse(cacheTTL.value);
      final cacheEnabled = useCache.value;

      print("[CacheSettingsFormBloc] Updating cache settings: TTL=$ttl, CacheEnabled=$cacheEnabled.");
      await _cacheService.setGlobalTTL(ttl);
      await _settingsService.setCacheEnabled(cacheEnabled);

      emitSuccess(successResponse: 'Cache settings updated successfully.');
    } catch (e) {
      print("[CacheSettingsFormBloc] Error updating cache settings: $e");
      emitFailure(failureResponse: 'Failed to update cache settings.');
    }
  }

  /// Clears the entire cache using the service.
  Future<void> clearCache() async {
    emitSubmitting();
    try {
      print("[CacheSettingsFormBloc] Clearing all cache.");
      await _cacheService.clearAllCache();

      emitSuccess(successResponse: 'Cache cleared successfully.');
    } catch (e) {
      print("[CacheSettingsFormBloc] Error clearing cache: $e");
      emitFailure(failureResponse: 'Failed to clear cache.');
    }
  }

  static String? _numberValidator(String? value) {
    if (value == null || value.isEmpty) {
      return 'This field is required.';
    }
    final number = int.tryParse(value);
    if (number == null || number <= 0) {
      return 'Enter a valid number greater than 0.';
    }
    return null;
  }
}
