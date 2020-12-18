using System;
using SDL2;

namespace BeefChip
{
	static
	{
		public static App app;
	}

	class App : SDLApp
	{
		Font mFont ~ delete _;
		public CPU cpu ~ delete _;
		String opCode;

		public int pixelSize=10;


		public new void Init()
		{
			cpu = new CPU();
			cpu.LoadROM("dist/ROM/o");
			base.Init();
			mFont = new Font();
			mFont.Load("zorque.ttf", 12);
		}
		public override void Draw()
		{
			SDL.RenderClear(app.mRenderer);
			base.Draw();

			opCode= scope String()..AppendF("Current opcode: 0x{0:X4}",(cpu.opcode & 0xF000));
			DrawString(0,10,opCode,SDL.Color(255,255,255,255));


			cpu.debugRender();

		}

		public this
		{
			app = this;
		}
		public override void Update()
		{
			base.Update();

			cpu.emulateCycle();
		}

		public void DrawPixel(int32 x, int32 y){
			SDL.RenderSetScale( mRenderer, pixelSize, pixelSize);
			SDL.RenderDrawPoint(mRenderer,x,y);
			SDL.RenderSetScale( mRenderer, 1, 1);
		}

		public void DrawString(float x, float y, String str, SDL.Color color, bool centerX = false)
		{
			var x;

			SDL.SetRenderDrawColor(mRenderer, 255, 255, 255, 255);
			let surface = SDLTTF.RenderUTF8_Blended(mFont.mFont, str, color);
			let texture = SDL.CreateTextureFromSurface(mRenderer, surface);
			SDL.Rect srcRect = .(0, 0, surface.w, surface.h);

			if (centerX)
				x -= surface.w / 2;

			SDL.Rect destRect = .((int32)x, (int32)y, surface.w, surface.h);
			SDL.RenderCopy(mRenderer, texture, &srcRect, &destRect);
			SDL.FreeSurface(surface);
			SDL.DestroyTexture(texture);
		}
	}
}