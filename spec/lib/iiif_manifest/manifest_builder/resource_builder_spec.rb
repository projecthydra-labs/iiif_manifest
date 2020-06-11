# frozen_string_literal: true
require 'spec_helper'

RSpec.describe IIIFManifest::ManifestBuilder::ResourceBuilder do
  let(:builder) do
    described_class.new(
      display_image,
      iiif_resource_factory: IIIFManifest::ManifestBuilder::IIIFManifest::Resource,
      image_service_builder_factory: image_service_builder_factory
    )
  end
  let(:url) { 'http://example.com/img1' }
  let(:display_image) { IIIFManifest::DisplayImage.new(url, width: 640, height: 480) }
  let(:annotation) { IIIFManifest::ManifestBuilder::IIIFManifest::Annotation.new }
  let(:image_service_builder_factory) { IIIFManifest::ManifestServiceLocator.image_service_builder_factory }

  describe '#apply' do
    subject { builder.apply(annotation) }

    context 'without iiif_endpoint' do
      it 'sets a resource on the annotation' do
        subject
        expect(annotation.resource).to be_kind_of IIIFManifest::ManifestBuilder::IIIFManifest::Resource
        expect(annotation.resource['@id']).to eq url
        expect(annotation.resource['@type']).to eq 'dctypes:Image'
        expect(annotation.resource).not_to have_key 'service'
      end
    end

    context 'with iiif_endpoint' do
      let(:iiif_endpoint) { IIIFManifest::IIIFEndpoint.new('http://example.com/') }
      let(:display_image) do
        IIIFManifest::DisplayImage.new(url, width: 640, height: 480, iiif_endpoint: iiif_endpoint)
      end

      it 'sets a resource on the annotation' do
        subject
        expect(annotation.resource).to be_kind_of IIIFManifest::ManifestBuilder::IIIFManifest::Resource
        expect(annotation.resource['@id']).to eq url
        expect(annotation.resource['@type']).to eq 'dctypes:Image'
        expect(annotation.resource['service']).to be_kind_of IIIFManifest::ManifestBuilder::IIIFService
      end
    end
  end
end
