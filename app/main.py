from fastapi import FastAPI
import uvicorn

# Create a FastAPI application instance
# PT-BR: Cria uma instância da aplicação FastAPI
app = FastAPI(
    title="Mentoring AI/ML API",
    version="0.1.0",
)

@app.get("/healthz", tags=["Health"])
def health_check():
    """
    Checks if the application is running.
    Returns an 'ok' status to indicate that the service is alive.
    ---
    PT-BR:
    Verifica se a aplicação está rodando.
    Retorna um status 'ok' para indicar que o serviço está vivo.
    """
    return {"status": "ok"}

if __name__ == "__main__":
    # Run the application with Uvicorn when the script is called directly
    # PT-BR: Executa a aplicação com Uvicorn quando o script é chamado diretamente
    # Useful for local development
    # PT-BR: Útil para desenvolvimento local
    uvicorn.run(app, host="0.0.0.0", port=8000)