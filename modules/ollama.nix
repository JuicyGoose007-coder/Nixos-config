{ pkgs, ... }:

{
  # Local LLM backend for iris AI suggestions (consumed by home/iris.nix).
  # Runs on localhost:11434; kept local so nothing leaves the machine.
  services.ollama = {
    enable = true;
    # Vulkan GPU accel via the NVIDIA driver's ICD (modules/nvidia.nix) —
    # avoids the huge CUDA toolkit closure. Use pkgs.ollama for CPU-only.
    package = pkgs.ollama-vulkan;
    # Pulled automatically at service start (a few GB, first switch only).
    loadModels = [ "qwen2.5-coder" ];
  };
}
