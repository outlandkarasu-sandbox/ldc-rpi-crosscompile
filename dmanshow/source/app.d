import bindbc.sdl;
import bindbc.sdl.image;
import std.stdio;

enum FPS = 60;

void logError(size_t line = __LINE__)() {
    writefln("%d:%s", line, SDL_GetError());
}

void main() {
    immutable loadedVersion = loadSDL();
    if(loadedVersion != sdlSupport) {
        // SDL無しか未対応バージョンだった場合はエラー。
        if(loadedVersion == SDLSupport.noLibrary) {
            writefln("noLibrary");
            return;
        } else if(loadedVersion == SDLSupport.badLibrary) {
            writefln("badLibrary");
            return;
        }
    }

    writefln("SDL version: %s", loadedVersion);

    if (loadSDLImage() != sdlImageSupport) {
        writefln("image badLibrary");
        return;
    }

    writefln("SDL_Image version: %s", sdlImageSupport);

    if(SDL_Init(SDL_INIT_VIDEO) != 0) {
        logError();
        return;
    }
    scope(exit) SDL_Quit();

    writefln("%d", __LINE__);

    if(IMG_Init(IMG_INIT_PNG) != IMG_INIT_PNG) {
        logError();
        return;
    }
    scope(exit) IMG_Quit();

    writefln("%d", __LINE__);

    SDL_Window* window;
    SDL_Renderer* renderer;
    if(SDL_CreateWindowAndRenderer(640, 480, SDL_WINDOW_SHOWN, &window, &renderer) != 0) {
        logError();
        return;
    }
    scope(exit) {
        SDL_DestroyRenderer(renderer);
	    SDL_DestroyWindow(window);
    }

    writefln("%d", __LINE__);

    auto dman = IMG_Load("./asset/dman.png");
    if(!dman) {
        logError();
        return;
    }
    scope(exit) SDL_FreeSurface(dman);

    writefln("%d", __LINE__);

    auto texture = SDL_CreateTextureFromSurface(renderer, dman);
    if(!texture) {
        logError();
        return;
    }
    scope(exit) SDL_DestroyTexture(texture);

    writefln("%d", __LINE__);

    // 1フレーム当たりのパフォーマンスカウンタ値計算。FPS制御のために使用する。
    immutable performanceFrequency = SDL_GetPerformanceFrequency();
    immutable countPerFrame = performanceFrequency / FPS;

    // メインループ
    mainLoop: for(;;) {
        immutable frameStart = SDL_GetPerformanceCounter();

        // イベントがキューにある限り処理を行う。           
        for(SDL_Event e; SDL_PollEvent(&e);) {
            switch(e.type) {
            case SDL_QUIT:
                break mainLoop;
            default:
                break;
            }
        }

        // 描画実行
        SDL_SetRenderDrawColor(renderer, 0x00, 0x00, 0x00, 0x00);
        SDL_RenderClear(renderer);
        SDL_RenderCopy(renderer, texture, null, null);
        SDL_RenderPresent(renderer);

        // 次フレームまで待機
        immutable drawDelay = SDL_GetPerformanceCounter() - frameStart;
        if(countPerFrame < drawDelay) {
            SDL_Delay(0);
        } else {
            SDL_Delay(cast(uint)((countPerFrame - drawDelay) * 1000 / performanceFrequency));
        }
    }
}

