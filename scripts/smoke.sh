#!/usr/bin/env bash
set -euo pipefail

GREEN="\033[1;32m"; YELLOW="\033[1;33m"; RED="\033[1;31m"; BLUE="\033[1;34m"; NC="\033[0m"
ok(){   echo -e "${GREEN}✔ OK${NC}  $*"; }
warn(){ echo -e "${YELLOW}▲ WARN${NC} $*"; }
fail(){ echo -e "${RED}✖ FAIL${NC} $*"; }
info(){ echo -e "${BLUE}ℹ${NC} $*"; }

FAILED=0
require_cmd(){
  local c="$1"
  if command -v "$c" >/dev/null 2>&1; then ok "Comando encontrado: '$c'"; else fail "Comando não encontrado: '$c'"; FAILED=$((FAILED+1)); fi
}

info "Verificando WSL/Ubuntu e filesystem…"
if grep -qi microsoft /proc/version; then ok "WSL detectado."; else warn "WSL não detectado."; fi
case "$(pwd)" in /mnt/*) warn "Você está em /mnt (I/O lento). Use ~/src/...";; *) ok "Diretório dentro do FS do WSL (bom).";; esac

info "VS Code CLI…"
require_cmd code

info "Git/SSH…"
require_cmd git

info "Conda & ambiente…"
if command -v conda >/dev/null 2>&1; then ok "Conda ok: $(conda --version)"; else fail "Conda não encontrada."; FAILED=$((FAILED+1)); fi

info "Docker…"
if require_cmd docker; then
  docker info >/dev/null 2>&1 && ok "Docker daemon acessível." || { fail "Docker daemon inacessível (abra o Docker Desktop e habilite a WSL Integration)."; FAILED=$((FAILED+1)); }
fi

info "Azure CLI…"
if require_cmd az; then
  az account show >/dev/null 2>&1 && ok "Azure CLI logada." || warn "Sem login no Azure CLI. Rode: az login"
fi

echo
if [ "$FAILED" -gt 0 ]; then echo -e "${RED}Resumo: ${FAILED} falha(s) crítica(s). Corrija antes de continuar.${NC}"; exit 1; else echo -e "${GREEN}Resumo: Ambiente essencial parece OK. Bom trabalho!${NC}"; exit 0; fi