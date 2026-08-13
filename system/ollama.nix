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
    loadModels = [
      "qwen2.5-coder:3b"
    ];

    # Keep the loaded model resident instead of evicting it after ~5 min idle.
    # loadModels warms qwen2.5-coder:3b at boot; without this the default idle
    # timer unloads it, so the next `git aic` / iris call pays a cold reload of
    # the ~2GB model into VRAM. "-1" = never unload (trades ~2GB of VRAM for
    # always-warm, instant responses). Use e.g. "1h" to free VRAM when idle for
    # a while instead.
    environmentVariables.OLLAMA_KEEP_ALIVE = "-1";
  };
}
