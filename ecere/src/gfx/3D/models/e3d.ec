import "e3dRead"
import "e3dWrite"

public class E3DFormat : ObjectFormat
{
   class_property(extension) = "e3d";

   static bool Load(Object object, const char * fileName, DisplaySystem displaySystem, void * options)
   {
      File f = FileOpen(fileName, read);
      if(f)
      {
         readE3D(f, fileName, object, displaySystem, options);
         delete f;
         return true;
      }
      return false;
   }

   bool Save(Object object, const char * fileName, void * options)
   {
      File f = FileOpen(fileName, write);
      if(f)
      {
         //char path[MAX_LOCATION];
         // E3DContext ctx { path = path, texturesByID = options.texturesByID };
         StripLastDirectory(fileName, e3dModelsPath);

         writeE3D(f, /*fileName, */object/*, options*/);
         delete f;
         return true;
      }
      return false;
   }

   static Array<String> listTextures(File modelFile, const String fileName, void * options)
   {
      Array<String> textures { };

      char path[MAX_LOCATION];
      E3DOptions * e3dOptions;
      E3DContext ctx { path = path };
      if(options) e3dOptions = options;

      if(e3dOptions->texturesByID)
      {
         ctx.texturesByID = e3dOptions->texturesByID;
         ctx.materials = e3dOptions->materials;
         ctx.texturesQuery = e3dOptions->texturesQuery;
         ctx.positiveYUp = e3dOptions->positiveYUp;
         ctx.resolution = e3dOptions->resolution;
         ctx.compressedTextures = e3dOptions->compressedTextures;
      }
      else
         ctx.texturesByID = { };

      listTexturesReadBlocks(ctx, modelFile, 0, 0, modelFile.GetSize(), null, textures);

      delete ctx;

      return textures;
   }
};

