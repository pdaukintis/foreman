module Api
  module V2
    class OverrideValuesController < V2::BaseController
      include Api::Version2
      include Api::V2::LookupKeysCommonController

      before_filter :find_override_values
      before_filter :find_override_value, :only => [:show, :update, :destroy]
      # override return_if_smart_mismatch in LookupKeysCommonController to add :index, :create
      before_filter :return_if_smart_mismatch, :only => [:index, :create, :show, :update, :destroy]
      before_filter :return_if_override_mismatch, :only => [:show, :update, :destroy]

      api :GET, '/smart_variables/:smart_variable_id/override_values', 'List of override values for a specific smart_variable'
      api :GET, '/smart_class_parameters/:smart_class_parameter_id/override_values', 'List of override values for a specific smart class parameter'
      param :smart_variable_id, :identifier, :required => false
      param :smart_class_parameter_id, :identifier, :required => false
      param :page, String, :desc => 'paginate results'
      param :per_page, String, :desc => 'number of entries per request'

      def index
      end

      api :GET, '/smart_variables/:smart_variable_id/override_values/:id', 'Show an override value for a specific smart_variable'
      api :GET, '/smart_class_parameters/:smart_class_parameter_id/override_values/:id', 'Show an override value for a specific smart class parameter'
      param :smart_variable_id, :identifier, :required => false
      param :smart_class_parameter_id, :identifier, :required => false
      param :id, :identifier, :required => true

      def show
      end

      api :POST, '/smart_variables/:smart_variable_id/override_values', 'Create an override value for a specific smart_variable'
      api :POST, '/smart_class_parameters/:smart_class_parameter_id/override_values', 'Create an override value for a specific smart class parameter'
      param :smart_variable_id, :identifier, :required => false
      param :smart_class_parameter_id, :identifier, :required => false
      param :override_value, Hash, :required => true do
        param :match, String
        param :value, String
      end

      def create
        @override_value = @smart.lookup_values.create!(params[:override_value])
      end

      api :PUT, '/smart_variables/:smart_variable_id/override_values/:id', 'Update an override value for a specific smart_variable'
      api :PUT, '/smart_class_parameters/:smart_class_parameter_id/override_values/:id', 'Update an override value for a specific smart class parameter'
      param :smart_variable_id, :identifier, :required => false
      param :smart_class_parameter_id, :identifier, :required => false
      param :override_value, Hash, :required => true do
        param :match, String
        param :value, String
      end

      def update
        @override_value.update_attributes!(params[:override_value])
        render 'api/v2/override_values/show'
      end

      api :DELETE, '/smart_variables/:smart_variable_id/override_values/:id', 'Delete an override value for a specific smart_variable'
      api :DELETE, '/smart_class_parameters/:smart_class_parameter_id/override_values/:id', 'Delete an override value for a specific smart class parameter'
      param :smart_variable_id, :identifier, :required => false
      param :smart_class_parameter_id, :identifier, :required => false
      param :id, :identifier, :required => true

      def destroy
        @override_value.destroy
        render 'api/v2/override_values/show'
      end

      def find_override_values
        @override_values = @smart.lookup_values.paginate(paginate_options) if @smart
      end

      def find_override_value
        @override_value = LookupValue.find_by_id(params[:id])
      end

      def return_if_override_mismatch
        if (@override_values && @override_value && !@override_values.find_by_id(@override_value.id)) || (@override_values && !@override_value) || !@override_values
          msg = "Override value not found by id '#{params[:id]}'"
          render :json => {:message => msg}, :status => :not_found and return false
        end
      end

    end
  end
end