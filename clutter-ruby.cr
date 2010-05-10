%min-version 0.0.8
%pkg-config gtk+-2.0
%pkg-config clutter-1.0
%pkg-config clutter-gtk-0.10
%pkg-config cairo
%name clutter

%{

inline void my_init(VALUE self, GObject *_self) {
	g_object_ref(_self);
	g_object_ref_sink(_self);
	G_INITIALIZE(self, _self);
}
#define INIT_GOBJECT(value) my_init(self, G_OBJECT(value));

#define CONVERT_PROPERTIES_TO_GVALUES()	volatile VALUE propkeys = rb_funcall(properties, rb_intern("keys"), 0); \
			int i, n_props = RARRAY_LEN(propkeys);  															\
			char **names = {0,};																				\
			GValue value = { 0, };																				\
    	    GValueArray *values;																				\
			GParamSpec* spec;																					\
																												\
			names = ALLOC_N(char*, n_props+1);																	\
			values = g_value_array_new(n_props);																\
																												\
			for (i = 0; i < n_props; i++) {																		\
				volatile VALUE key =  (RARRAY(propkeys)->ptr[i]);												\
				volatile VALUE rvalue = rb_hash_lookup(properties, key);										\
																												\
				names[i] = RSTRING_PTR(key);																	\
				spec = g_object_class_find_property(G_OBJECT_GET_CLASS(_self), names[i]);						\
				g_value_init(&value, spec->value_type);															\
				rbgobj_rvalue_to_gvalue(rvalue, &value);														\
																												\
				g_value_array_append(values, &value);															\
				g_value_unset(&value);																			\
			}

%}
 
%include clutter/clutter.h
%include clutter-gtk/clutter-gtk.h
%include rb_cairo.h

module Clutter
	array BUILD_VERSION = [ CLUTTER_MAJOR_VERSION, CLUTTER_MINOR_VERSION, CLUTTER_MICRO_VERSION ]
	array BINDING_VERSION = [ 0, 9, 0 ]
	string FLAVOUR = CLUTTER_FLAVOUR
	string COGL = CLUTTER_COGL

	gobject Gtk < GTK_CLUTTER_TYPE_EMBED
		@type GtkClutterEmbed
		def self.init
			gtk_clutter_init(0,NULL);
		end
		def initialize()
			RBGTK_INITIALIZE(self, gtk_clutter_embed_new());
		end
		def ClutterActor*:stage
			return gtk_clutter_embed_get_stage(_self);
		end
	end
	enum Gravity (CLUTTER_GRAVITY_NONE,
  CLUTTER_GRAVITY_NORTH,
  CLUTTER_GRAVITY_NORTH_EAST,
  CLUTTER_GRAVITY_EAST,
  CLUTTER_GRAVITY_SOUTH_EAST,
  CLUTTER_GRAVITY_SOUTH,
  CLUTTER_GRAVITY_SOUTH_WEST,
  CLUTTER_GRAVITY_WEST,
  CLUTTER_GRAVITY_NORTH_WEST,
  CLUTTER_GRAVITY_CENTER)
	gobject Actor < CLUTTER_TYPE_ACTOR
		@type ClutterActor
		def show
			clutter_actor_show(_self);
		end
		def set_gravity(Gravity gravity)
			clutter_actor_set_anchor_point_from_gravity(_self, gravity);
		end
		def Gravity:get_gravity
			return clutter_actor_get_anchor_point_gravity(_self);
		end
		def show_all
			clutter_actor_show_all(_self);
		end
		def set_size(gfloat width, gfloat height)
			clutter_actor_set_size(_self, width, height);
		end
		def set_x(gfloat x)
			clutter_actor_set_x(_self, x);
		end
		def set_y(gfloat y)
			clutter_actor_set_y(_self, y);
		end
		def set_opacity(int opacity)
			clutter_actor_set_opacity(_self, opacity);
		end
		def int:get_opacity
			return clutter_actor_get_opacity(_self);
		end
		def set_scale(gdouble x_scale, gdouble y_scale)
			clutter_actor_set_scale(_self, x_scale, y_scale);
		end
		def destroy!
			clutter_actor_destroy(_self);
		end
		def hide
			clutter_actor_hide(_self);
		end
		def lower(ClutterActor *above)
			clutter_actor_lower(_self, above);
		end
		def lower_bottom
			clutter_actor_lower_bottom(_self);
		end
		def raise(ClutterActor *below)
			clutter_actor_raise(_self, below);
		end
		def raise_top
			clutter_actor_raise_top(_self);
		end
		% def set_z(gfloat z)
		% 	clutter_actor_set_z(_self, z);
		% end
		def ClutterAnimation*:animate(Mode mode, guint duration, T_HASH properties)
			CONVERT_PROPERTIES_TO_GVALUES()
			
			return clutter_actor_animatev(_self, mode, duration, n_props, (const gchar * const *)names, values->values);
		end
		def ClutterAnimation*:animate_with_timeline(Mode mode, ClutterTimeline *timeline, T_HASH properties)
			CONVERT_PROPERTIES_TO_GVALUES()

			return clutter_actor_animate_with_timelinev(_self, mode, timeline, n_props,  (const gchar * const *)names, values->values);
		end
		def ClutterAnimation*:animate_with_alpha(ClutterAlpha *alpha, T_HASH properties)
			CONVERT_PROPERTIES_TO_GVALUES()

			return clutter_actor_animate_with_alphav(_self, alpha, n_props, (const gchar * const *)names, values->values);
		end
	end

	gobject Container < CLUTTER_TYPE_CONTAINER
		@type ClutterContainer
		def add(ClutterActor *actor)
			clutter_container_add(_self, actor, NULL);
		end
	end

	enum Mode (CLUTTER_LINEAR,
  CLUTTER_EASE_IN_QUAD,
  CLUTTER_EASE_OUT_QUAD,
  CLUTTER_EASE_IN_OUT_QUAD,
  CLUTTER_EASE_IN_CUBIC,
  CLUTTER_EASE_OUT_CUBIC,
  CLUTTER_EASE_IN_OUT_CUBIC,
  CLUTTER_EASE_IN_QUART,
  CLUTTER_EASE_OUT_QUART,
  CLUTTER_EASE_IN_OUT_QUART,
  CLUTTER_EASE_IN_QUINT,
  CLUTTER_EASE_OUT_QUINT,
  CLUTTER_EASE_IN_OUT_QUINT,
  CLUTTER_EASE_IN_SINE,
  CLUTTER_EASE_OUT_SINE,
  CLUTTER_EASE_IN_OUT_SINE,
  CLUTTER_EASE_IN_EXPO,
  CLUTTER_EASE_OUT_EXPO,
  CLUTTER_EASE_IN_OUT_EXPO,
  CLUTTER_EASE_IN_CIRC,
  CLUTTER_EASE_OUT_CIRC,
  CLUTTER_EASE_IN_OUT_CIRC,
  CLUTTER_EASE_IN_ELASTIC,
  CLUTTER_EASE_OUT_ELASTIC,
  CLUTTER_EASE_IN_OUT_ELASTIC,
  CLUTTER_EASE_IN_BACK,
  CLUTTER_EASE_OUT_BACK,
  CLUTTER_EASE_IN_OUT_BACK,
  CLUTTER_EASE_IN_BOUNCE,
  CLUTTER_EASE_OUT_BOUNCE,
  CLUTTER_EASE_IN_OUT_BOUNCE)


	gobject Alpha < CLUTTER_TYPE_ALPHA
		@type ClutterAlpha
		def initialize(ClutterTimeline *timeline = NULL, Mode mode = -1)
			if ((timeline != NULL) && (mode > -1)) {
				INIT_GOBJECT(clutter_alpha_new_full(timeline, mode));
			} else {
				INIT_GOBJECT(clutter_alpha_new());
			}
		end
		def Mode:get_mode
			return clutter_alpha_get_mode(_self);
		end
		def set_mode(Mode mode)
			clutter_alpha_set_mode(_self, mode);
		end
	end

	gobject Animation < CLUTTER_TYPE_ANIMATION
		@type ClutterAnimation
		def initialize()
			INIT_GOBJECT(clutter_animation_new());
		end
		def GObject*:get_object
			return clutter_animation_get_object(_self);
		end
	end

	gobject Stage < CLUTTER_TYPE_STAGE
		@type ClutterStage
		def initialize()
			INIT_GOBJECT(clutter_stage_new());
		end
		def ClutterStage*:self.default
			return clutter_stage_get_default();
		end
	end

	gobject Rectangle < CLUTTER_TYPE_RECTANGLE
		@type ClutterRectangle
		def ClutterColor*:get_color
			ClutterColor *col = clutter_color_new(1,1,1,1);
			clutter_rectangle_get_color(_self, col);
			return col;
		end
		def set_color(ClutterColor *col)
			clutter_rectangle_set_color(_self, col);
		end
		def ClutterColor*:get_border_color
			ClutterColor *col = clutter_color_new(1,1,1,1);
			clutter_rectangle_get_border_color(_self, col);
			return col;
		end
		def set_border_color(ClutterColor *col)
			clutter_rectangle_set_border_color(_self, col);
		end
		def set_border_width(guint width)
			clutter_rectangle_set_border_width(_self, width);
		end
		def guint:get_border_width
			return clutter_rectangle_get_border_width(_self);
		end

	end

	gobject Texture < CLUTTER_TYPE_TEXTURE
		@type ClutterTexture
		pre_func GError *error = NULL;
		post_func if (error) RAISE_GERROR(error);

		def initialize(T_STRING|T_DATA fileOrActor = Qnil)
			
			if (fileOrActor == Qnil) {
				INIT_GOBJECT(clutter_texture_new());
			} else if (TYPE(fileOrActor) == T_STRING) {
				INIT_GOBJECT(clutter_texture_new_from_file(RSTRING_PTR(fileOrActor), &error));
			} else if ((TYPE(fileOrActor) == T_DATA) && rb_obj_is_kind_of(fileOrActor, cActor)) {
				INIT_GOBJECT(clutter_texture_new_from_actor(CLUTTER_ACTOR(RVAL2GOBJ(fileOrActor))));
			} else if ((TYPE(fileOrActor) == T_DATA) && rb_obj_is_kind_of(fileOrActor, GTYPE2CLASS(GDK_TYPE_PIXBUF))) {
				INIT_GOBJECT(gtk_clutter_texture_new_from_pixbuf(GDK_PIXBUF(RVAL2GOBJ(fileOrActor))));
			}
		end
	end

%	ginterface Animatable < CLUTTER_TYPE_ANIMATABLE
%		def animate(ClutterAnimation *animation, char *property, VALUE initial_val, VALUE final_val, gdouble progress, 
%	end

	gboxed Color < CLUTTER_TYPE_COLOR
		@type ClutterColor
		def initialize(int r, int g, int b, int a)
			G_INITIALIZE(self, clutter_color_new(r,g,b,a));
		end
		def char*:to_s
			return clutter_color_to_string(_self);
		end
		def bool:from_string(char *str)
			return clutter_color_from_string(_self, str);
		end
	end

	gobject Timeline < CLUTTER_TYPE_TIMELINE
		@type ClutterTimeline
		def initialize(guint msecs)
			INIT_GOBJECT(clutter_timeline_new(msecs));
		end
		def guint:get_duration
			return clutter_timeline_get_duration(_self);
		end
		def set_duration(guint msecs)
			clutter_timeline_set_duration(_self, msecs);
		end
		def start
			clutter_timeline_start (_self);
		end
		def pause
			clutter_timeline_pause (_self);
		end
		def stop
			clutter_timeline_stop (_self);
		end
		def set_loop(bool loop)
			clutter_timeline_set_loop(_self, loop);
		end
		def bool:get_loop
			return clutter_timeline_get_loop(_self);
		end
		def rewind
			clutter_timeline_rewind(_self);
		end
		def skip(guint msecs)
			clutter_timeline_skip (_self, msecs);
		end
		def advance(guint msecs)
			clutter_timeline_advance (_self, msecs);
		end
		def guint:get_elapsed_time
			return clutter_timeline_get_elapsed_time (_self);
		end
		def gdouble:get_progress
			return clutter_timeline_get_progress (_self);
		end
		def bool:is_playing?
			return clutter_timeline_is_playing (_self);
		end
		def set_delay(guint msecs)
			clutter_timeline_set_delay (_self, msecs);
		end
		def guint:get_delay
			return clutter_timeline_get_delay (_self);
		end
		def guint:get_delta
			return clutter_timeline_get_delta(_self);
		end
		def add_marker_at_time(char *marker_name, guint msecs)
			clutter_timeline_add_marker_at_time (_self, marker_name, msecs);
		end
		def remove_marker(char *marker_name)
			clutter_timeline_remove_marker (_self, marker_name);
		end
		def list_markers(int msecs = -1)
			VALUE list = Qnil;
			gsize no_markers = 0;
			int i;
			gchar **markers;

			markers = clutter_timeline_list_markers(_self, msecs, &no_markers);
			list    = rb_ary_new2(no_markers);

			for (i=0; i < no_markers; i++) {
				rb_ary_push(list, rb_str_new2(markers[i]));
			}

			g_strfreev(markers);

			return list;
		end
		def gboolean:has_marker?(char *marker_name)
			return clutter_timeline_has_marker (_self, marker_name);
		end
		def advance_to_marker(char *marker_name)
			clutter_timeline_advance_to_marker (_self, marker_name);
		end
	end

	gobject Script < CLUTTER_TYPE_SCRIPT
		@type ClutterScript
		def initialize()
			INIT_GOBJECT(clutter_script_new());
		end
		pre_func GError *error = NULL;
		post_func if (error) RAISE_GERROR(error);
		def uint:load_from_file(char *filename)
			return clutter_script_load_from_file(_self, filename, &error);
		end
		def uint:load_from_data(T_STRING data)
			return clutter_script_load_from_data(_self, RSTRING_PTR(data), RSTRING_LEN(data), &error);
		end
		def GObject*:get_object(char *name)
			return clutter_script_get_object(_self, name);
		end
		def connect_signals
			clutter_script_connect_signals(_self, NULL);
		end
		alias :[] :get_object
		def add_search_paths(T_ARRAY paths)
			// FXIME	
		end
	end

	ginterface Media < CLUTTER_TYPE_MEDIA
		#@type ClutterMedia
		def set_uri(char *uri)
			clutter_media_set_uri(CLUTTER_MEDIA(_self), uri);
		end
		alias :uri= :set_uri
		def char *:get_uri
			return clutter_media_get_uri(CLUTTER_MEDIA(_self));
		end
		alias :uri :get_uri
		def set_filename(char *filename)
			clutter_media_set_filename(CLUTTER_MEDIA(_self), filename);
		end
	end

	gobject CairoTexture < CLUTTER_TYPE_CAIRO_TEXTURE
		@type ClutterCairoTexture
		def initialize(int width, int height)
			INIT_GOBJECT(clutter_cairo_texture_new(width, height));	
		end
		def create
			return CRCONTEXT2RVAL(clutter_cairo_texture_create(_self));
		end
		def create_region(x_offset, y_offset, width, height)
			return CRCONTEXT2RVAL(clutter_cairo_texture_create_region(_self, x_offset, y_offset, width, height));
		end
		def clear
			clutter_cairo_texture_clear(_self);
		end
	end

	gobject Score < CLUTTER_TYPE_SCORE
		@type ClutterScore
		def initialize
			INIT_GOBJECT(clutter_score_new());
		end
		def int:append(ClutterTimeline *parent, ClutterTimeline *timeline)
			return clutter_score_append(_self, parent, timeline);
		end
		def int:append_at_marker(ClutterTimeline *parent, char *marker_name, ClutterTimeline *timeline)
			return clutter_score_append_at_marker(_self, parent, marker_name, timeline);
		end
		def ClutterTimeline*:get_timeline(int id)
			return clutter_score_get_timeline(_self, id);
		end
		def list_timelines()
			return gslist_to_array_of_ClutterTimeline(clutter_score_list_timelines(_self));
		end
		alias :timelines :list_timelines
		def remove(int id)
			clutter_score_remove(_self, id);
		end
		def remove_all
			clutter_score_remove_all(_self);
		end
		alias :clear! :remove_all
		def start
			clutter_score_start(_self);
		end
		def stop
			clutter_score_stop(_self);
		end
		def pause
			clutter_score_pause(_self);
		end
		def rewind
			clutter_score_rewind(_self);
		end
		def bool:is_playing?
			return clutter_score_is_playing(_self);
		end
	end
	flags Feature (CLUTTER_FEATURE_TEXTURE_NPOT,
  CLUTTER_FEATURE_SYNC_TO_VBLANK,
  CLUTTER_FEATURE_TEXTURE_YUV,
  CLUTTER_FEATURE_TEXTURE_READ_PIXELS,
  CLUTTER_FEATURE_STAGE_STATIC,
  CLUTTER_FEATURE_STAGE_USER_RESIZE,
  CLUTTER_FEATURE_STAGE_CURSOR,
  CLUTTER_FEATURE_SHADERS_GLSL,
  CLUTTER_FEATURE_OFFSCREEN,
  CLUTTER_FEATURE_STAGE_MULTIPLE)
	def Feature:self.feature_get_all
		return clutter_feature_get_all();
	end
	def bool:self.feature_available?(Feature feature)
		return clutter_feature_available(feature);
	end
	def self.base_init
		clutter_base_init();
	end
	def self.init
		clutter_init(0, NULL);
	end
	def self.main	
		clutter_main();
	end
	def self.main_quit
		clutter_main_quit();
	end
	def int:main_level
		return clutter_main_level();
	end
end
module Cogl
end
