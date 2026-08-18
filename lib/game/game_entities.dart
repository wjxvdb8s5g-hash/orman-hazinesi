/// Marker mixin for components that harm the player on contact
mixin HarmfulComponent {}

/// Marker mixin for components that can be collected by the player
mixin CollectibleComponent {
  void collect();
}

/// Marker mixin for the player character component
mixin PlayerComponent {}
