ActiveStorage::Engine.config.active_storage.content_types_to_serve_as_binary.delete('image/svg+xml')
ActiveStorage::Engine.config.active_storage.analyzers.append(ActiveStorage::Analyzer::ExtendedImageAnalyzer)
ActiveStorage::Engine.config.active_storage.analyzers.delete(ActiveStorage::Analyzer::ImageAnalyzer)