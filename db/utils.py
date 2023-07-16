import os
import openai
from typing import List
import pinecone
from dotenv import load_dotenv

load_dotenv()

openai.api_key = os.getenv("OPENAI_API_KEY")
API_KEY_PINECONE = os.getenv("PINECONE_API_KEY")
PINECONE_ENVIRONMENT = os.getenv("PINECONE_ENVIRONMENT")
PINECONE_ENDPOINT = os.getenv("PINECONE_ENDPOINT")
PINECONE_INDEX_NAME = "hormozi-gpt"

# ============================================== #
# GET EMBEDDINGS FOR A GIVEN STRING              #
# ============================================== #


def get_embeddings_openai(text: str) -> List[List[float]]:
    response = openai.Embedding.create(
        input=text,
        model="text-embedding-ada-002"
    )
    response = response['data']

    # extract embeddings from responses0
    return [x["embedding"] for x in response]

# ============================================== #
# SEARCH PINECONE FOR SIMILAR DOCUMENTS          #
# ============================================== #


def semantic_search(query: str, **kwargs):

    # Embed the query into a vector
    embeddings = get_embeddings_openai(query)

    # Check that the pinecone environment variables are set
    if not API_KEY_PINECONE or not PINECONE_ENVIRONMENT or not PINECONE_ENDPOINT:
        raise ValueError(
            "Please set the PINECONE_API_KEY, PINECONE_ENVIRONMENT, and PINECONE_ENDPOINT environment variables."
        )

    # Start the Pinecone client and get the index
    pinecone.init(
        api_key=API_KEY_PINECONE,
        environment=PINECONE_ENVIRONMENT
    )
    index = pinecone.Index(
        index_name=PINECONE_INDEX_NAME
    )

    # Query the index
    res = index.query(
        top_k=int(kwargs["top_k"]) if "top_k" in kwargs else 1,
        vector=embeddings[0],
        include_metadata=(
            False if "include_metadata" in kwargs and not kwargs["include_metadata"] else True
        )
    )

    # Try to return the results
    try:
        matches = res["matches"]
        files = [r["metadata"]["filename"] for r in matches]
        sentences = [r["metadata"]["text"] for r in matches]
        return list(zip(files, sentences))

    except Exception as e:
        print(f"Error in semantic search: {e}")
        raise
